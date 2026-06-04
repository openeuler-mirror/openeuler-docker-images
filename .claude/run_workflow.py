#!/usr/bin/env python3
"""openEuler Container Image Contribution Workflow.
Usage: python3 run_workflow.py --app-name X --app-version Y --source-repo URL --category Z --oe-version V
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

SCRIPTS_DIR = Path(__file__).resolve().parent / "scripts"
AGENTS_DIR = Path(__file__).resolve().parent
REPO_ROOT = AGENTS_DIR.parent
CLAUDE_MD = AGENTS_DIR / "CLAUDE.md"

IMAGEINFO_ORDER = ["name","category","description","environment","tags","download","usage","license","similar_packages","dependency","homepage","upstream"]

@dataclass
class Config:
    app_name: str; app_version: str; source_repo: str; category: str; oe_version: str
    description: str = ""; dry_run: bool = False
    max_qa_rounds: int = 2; max_fix_rounds: int = 4
    skip_validate: bool = False; remote_host: Optional[str] = None
    repo_path: str = str(REPO_ROOT)

    @property
    def tag(self): return _tag(self.app_version, self.oe_version)
    @property
    def dfile_rel(self): return f"{self.category}/{self.app_name}/{self.app_version}/{self.oe_version}/Dockerfile"
    @property
    def dfile_abs(self): return os.path.join(self.repo_path, self.dfile_rel)

def _tag(ver, oe):
    m = re.match(r'(\d{2})\.(\d{2})(?:-lts)?(?:-sp(\d+))?', oe)
    if m:
        y, mm, s = m.groups()
        a = f'oe{y}{mm}'
        return f'{ver}-{a}{"sp"+s if s else "lts" if "lts" in oe.lower() else ""}'
    return f'{ver}-{oe.lower().replace(".","").replace("-","")}'

# ---- claude CLI ----

def _claude(prompt: str, timeout: int = 3600, model: str = "haiku", effort: str = "low") -> Optional[str]:
    if not shutil.which("claude"): return None
    try:
        r = subprocess.run(["claude","-p","OUTPUT TEXT ONLY.\n\n"+prompt,"--print","--output-format","text","--permission-mode","bypassPermissions","--model",model,"--effort",effort],
                          capture_output=True, text=True, timeout=timeout, env={**os.environ,"CLAUDE_CODE_NO_COLOR":"1"})
        if r.returncode == 0 and r.stdout.strip(): return r.stdout.strip()
    except: pass
    return None

def _claude_json(prompt: str, schema: dict, timeout: int = 3600) -> Optional[dict]:
    full = f"Return ONLY JSON matching this schema:\n{json.dumps(schema,indent=2)}\n\n{prompt}"
    text = _claude(full, timeout=timeout)
    if not text: return None
    for fn in [lambda: json.loads(text), lambda: json.loads(re.search(r'\{[\s\S]*\}', text).group(0))]:
        try: return fn()
        except: continue
    return None

def _extract(text: str, marker: str) -> Optional[str]:
    m = re.search(rf'===?\s*{marker}\s*===?\s*\n(.*?)(?=\n===?|$)', text, re.DOTALL)
    if m:
        c = m.group(1).strip(); c = re.sub(r'^```\w*\n','',c); c = re.sub(r'\n```$','',c)
        return c.strip()
    return None

# ---- Phase 1: Research ----

R_SCHEMA = {"type":"object","properties":{k:{"type":"string"} for k in ["build_system","build_deps","runtime_deps","source_url","download_type","extract_cmd","build_commands","install_commands","exposed_ports","entrypoint","cmd","workdir","volumes","env_vars","pre_install_commands","post_install_commands","test_command","notes"]},"required":["build_system","build_deps","source_url","build_commands","install_commands"]}

def phase_research(cfg: Config) -> Optional[dict]:
    print(f"\n{'='*60}\n  Phase 1: Research — {cfg.app_name} {cfg.app_version}\n{'='*60}")
    p = f"Research {cfg.app_name} {cfg.app_version} from {cfg.source_repo} for openEuler {cfg.oe_version}. Determine build system, yum deps, source URL, build/install commands, ports, entrypoint. Map Debian names to RPM: libssl-dev→openssl-devel, build-essential→gcc gcc-c++ make, shadow→shadow-utils, etc."
    if cfg.dry_run: return {"build_system":"cmake","build_deps":"gcc","source_url":"...","build_commands":"make","install_commands":"make install"}
    r = _claude_json(p, R_SCHEMA)
    if r: print(f"     Build: {r.get('build_system')}, Source: {r.get('source_url','')[:80]}")
    return r

# ---- Phase 2: Generate + QA ----

def _generate(cfg: Config, research: dict, fb: str = ""):
    n, v, o, c, t = cfg.app_name, cfg.app_version, cfg.oe_version, cfg.category, cfg.tag
    r = json.dumps({k: str(v)[:200] for k,v in research.items() if v})
    p = f"""Generate 5 sections for {n} {v} on openEuler {o} ({c}). Tag={t}.
Research: {r}
{fb}
===DOCKERFILE=== ARG BASE=openeuler/openeuler:{o}, FROM ${{BASE}}, ARG VERSION, yum -y, &&, cmake -S/-B, git -C, bash -c, 2>/dev/null||true, yum remove wget gcc make only, yum clean all, absolute binary paths.
===README=== TAB-indent code blocks, {{{{Tag}}}} placeholder, gitcode links, 6 sections.
===META=== {t}:\\n  path: {v}/{o}/Dockerfile (no v-prefix, relative to app dir).
===IMAGEINFO=== Field order: name→category→description→environment→tags→download→usage→license→similar_packages→dependency→homepage→upstream. Multi-line fields use YAML | block scalar, NOT quoted \\n strings. version_filter='' not null. Chinese content.
===LOGO=== Search web for official project logo URL. If not found, return USE_FALLBACK.
ALL 5 ===MARKER=== sections. No fences."""
    if cfg.dry_run: return ("FROM ...","# README",f"{t}:\n  path: ...","name: ...","https://...")
    r = _claude(p, model="haiku", effort="low")
    if not r: return (None,)*5
    return (_extract(r,"DOCKERFILE"), _extract(r,"README"), _extract(r,"META"), _extract(r,"IMAGEINFO"), _extract(r,"LOGO"))

def _fix_imageinfo(cfg: Config):
    p = Path(cfg.repo_path)/cfg.category/cfg.app_name/"doc"/"image-info.yml"
    if not p.exists(): return
    try:
        import yaml
        data = yaml.safe_load(p.read_text())
        if not isinstance(data, dict): return
        ordered = {}
        for k in IMAGEINFO_ORDER:
            if k in data:
                v = data[k]
                if k == "version_filter" and v is None: v = ""
                ordered[k] = v
        with open(p,'w') as f:
            for key, value in ordered.items():
                if key in ("environment","tags","download","usage"):
                    f.write(f"{key}: |\n")
                    for line in (value or "").strip().split('\n'): f.write(f"  {line}\n")
                elif key == "upstream":
                    f.write(f"{key}:\n")
                    for sub in ["version_url","backend","version_scheme","version_prefix","version_filter"]:
                        sv = value.get(sub,"") if isinstance(value,dict) else ""
                        f.write(f"  {sub}: {'' if sv is None else sv}\n")
                elif key == "similar_packages":
                    f.write(f"{key}:\n")
                    for pkg in (value or []):
                        if isinstance(pkg,dict):
                            for k,v in pkg.items(): f.write(f"  - {k}: {v}\n")
                        else: f.write(f"  - {pkg}\n")
                elif key == "dependency":
                    f.write(f"{key}:\n")
                    for d in (value or []): f.write(f"  - {d}\n")
                else:
                    f.write(f"{key}: {value}\n")
        print("     [image-info.yml fixed]")
    except Exception as e: print(f"     [image-info fix: {e}]")

def _write_files(cfg: Config, df, rm, mt, ii, logo):
    t = Path(tempfile.gettempdir())
    for n,c in [("dockerfile",df),("readme.md",rm),("meta.yml",mt)]:
        if not c: print(f"ERROR: {n} empty"); return
        (t/f"oe-{cfg.app_name}-{n}").write_text(c)
    iip = None
    if ii and ii.strip(): iip = t/f"oe-{cfg.app_name}-image-info.yml"; iip.write_text(ii)
    final_logo = logo.strip() if logo else ""
    if not final_logo or final_logo == "USE_FALLBACK":
        m = re.search(r'github\.com/([^/]+)', cfg.source_repo)
        if m: final_logo = f"https://avatars.githubusercontent.com/{m.group(1)}"
    cmd = [sys.executable, str(SCRIPTS_DIR/"generate_files.py"),"--app-name",cfg.app_name,"--version",cfg.app_version,"--category",cfg.category,"--oe-version",cfg.oe_version,"--dockerfile",str(t/f"oe-{cfg.app_name}-dockerfile"),"--readme",str(t/f"oe-{cfg.app_name}-readme.md"),"--meta",str(t/f"oe-{cfg.app_name}-meta.yml"),"--repo-path",cfg.repo_path]
    if iip: cmd += ["--image-info",str(iip)]
    if final_logo: cmd += ["--logo",final_logo]
    if cfg.dry_run: cmd.append("--dry-run")
    r = subprocess.run(cmd, capture_output=True, text=True)
    print(r.stdout)
    if r.returncode: print(r.stderr, file=sys.stderr)
    _fix_imageinfo(cfg)

def _qa(cfg: Config) -> Optional[dict]:
    print("\n  >> QA Review")
    fc = {}
    for label, fpath in [("Dockerfile",cfg.dfile_abs),("README",f"{cfg.repo_path}/{cfg.category}/{cfg.app_name}/README.md"),("meta.yml",f"{cfg.repo_path}/{cfg.category}/{cfg.app_name}/meta.yml"),("image-info.yml",f"{cfg.repo_path}/{cfg.category}/{cfg.app_name}/doc/image-info.yml")]:
        p = Path(fpath)
        if p.exists(): fc[label] = p.read_text()[:2000]
    p = f"""Review these files against the checklist in oe-generator-qa.md (DF/RM/MT/II/LG/CC/QL items).
Files (content injected):
Dockerfile: ```dockerfile\n{fc.get('Dockerfile','MISSING')}\n```
README: ```markdown\n{fc.get('README','MISSING')}\n```
meta.yml: ```yaml\n{fc.get('meta.yml','MISSING')}\n```
image-info.yml: ```yaml\n{fc.get('image-info.yml','MISSING')}\n```
App: {cfg.app_name} {cfg.app_version} / {cfg.category} / {cfg.oe_version} / Tag: {cfg.tag}
image-list.yml must have `{cfg.app_name}: {cfg.app_name}`, logo.png must exist.
Return JSON: verdict (PASS/FAIL/NEEDS_FIX) + issues (id, severity={{"BLOCKER","HIGH","MEDIUM","LOW"}}, description, fix)."""
    s = {"type":"object","properties":{"verdict":{"type":"string","enum":["PASS","FAIL","NEEDS_FIX"]},"issues":{"type":"array","items":{"type":"object","properties":{"id":{"type":"string"},"severity":{"type":"string"},"description":{"type":"string"},"fix":{"type":"string"}}}}},"required":["verdict","issues"]}
    if cfg.dry_run: return {"verdict":"PASS","issues":[]}
    return _claude_json(p, s)

def phase_gen_qa(cfg: Config, research: dict) -> bool:
    print(f"\n{'='*60}\n  Phase 2: Generate + QA\n{'='*60}")
    last_qa = None
    for rd in range(1, cfg.max_qa_rounds+1):
        print(f"\n  -- Round {rd}/{cfg.max_qa_rounds} --")
        fb = ""
        if last_qa:
            ki = [i for i in last_qa.get("issues",[]) if i.get("severity") in ("BLOCKER","HIGH","FAIL")][:3]
            fb = "FIX:\n"+json.dumps(ki, indent=2) if ki else ""
        df, rm, mt, ii, logo = _generate(cfg, research, fb)
        if not df: print("ERROR: generation failed"); return False
        _write_files(cfg, df, rm, mt, ii, logo)
        last_qa = _qa(cfg)
        if not last_qa: print("QA skipped"); return True
        vi = last_qa.get("verdict","FAIL"); iss = last_qa.get("issues",[])
        bl = len([i for i in iss if i.get("severity")=="BLOCKER"]); hi = len([i for i in iss if i.get("severity") in ("HIGH","FAIL")])
        print(f"     {vi} | {len(iss)} issues ({bl}B/{hi}H)")
        for i in iss: print(f"       [{i.get('severity','?')}] {i.get('id','?')}: {i.get('description','')[:100]}")
        if vi == "PASS": print("QA PASSED"); return True
        if rd >= cfg.max_qa_rounds: print("Max QA rounds"); return False
    return False

# ---- Validate + Fix ----
def phase_validate_fix(cfg: Config) -> bool:
    print(f"\n{'='*60}\n  Phase 3+4: Validate + Fix\n{'='*60}")
    s = SCRIPTS_DIR / "validate_dockerfile.py"; b = f"openeuler/openeuler:{cfg.oe_version}"
    jf = Path(tempfile.gettempdir()) / f"v_{cfg.app_name}.json"
    if cfg.remote_host:
        rd = f"/tmp/oe-v-{cfg.app_name}"
        subprocess.run(["ssh",cfg.remote_host,"mkdir","-p",rd], capture_output=True, timeout=30)
        subprocess.run(["scp",str(s),cfg.dfile_abs,f"{cfg.remote_host}:{rd}/"], capture_output=True, timeout=30)
    for rd in range(1, cfg.max_fix_rounds+1):
        print(f"\n  -- Round {rd}/{cfg.max_fix_rounds} --")
        if cfg.remote_host:
            cmd = f"cd {rd} && python3 validate_dockerfile.py Dockerfile --base-image {b} --round {rd} --timeout 3600 --json-output result.json"
            r = subprocess.run(["ssh",cfg.remote_host,cmd], capture_output=True, text=True, timeout=3600)
            print(r.stdout[-1000:] if len(r.stdout)>1000 else r.stdout)
            try: subprocess.run(["scp",f"{cfg.remote_host}:{rd}/result.json",str(jf)], capture_output=True, timeout=30)
            except: pass
        else:
            if cfg.dry_run: print("[DRY RUN]"); return True
            r = subprocess.run([sys.executable,str(s),cfg.dfile_abs,"--base-image",b,"--round",str(rd),"--timeout","3600","--json-output",str(jf)], capture_output=True, text=True, timeout=3600)
            print(r.stdout[-1000:] if len(r.stdout)>1000 else r.stdout)
        if not jf.exists(): print("No results"); return False
        d = json.loads(jf.read_text())
        if d.get("success"): print(f"\nALL {d['total_commands']} PASSED!"); return True
        print(f"{d['passed']}/{d['total_commands']} passed, {d['failed']} failed")
        if rd >= cfg.max_fix_rounds: return False
        fs = d.get("failures",[])
        if not fs: continue
        ft = "\n".join(f"- {f['command'][:120]}\n  {f['error'][:200]}" for f in fs[:3])
        fp = f"""Fix this Dockerfile. Failed in openEuler {cfg.oe_version}:\n{ft}\nCurrent:\n```dockerfile\n{Path(cfg.dfile_abs).read_text()}\n```\nUse absolute binary paths, bash -c for arch detect, yum remove wget gcc make ONLY. Return fixed Dockerfile."""
        fx = _claude(fp, model="haiku", effort="low")
        if fx:
            fx = _extract(fx,"DOCKERFILE") or fx; fx = re.sub(r'^```\w*\n|```$','',fx).strip()
            if fx.startswith("ARG BASE") or fx.startswith("FROM"):
                Path(cfg.dfile_abs).write_text(fx+"\n"); print("Dockerfile updated"); continue
        print("Fix failed"); return False
    return False

# ---- Submit ----
def phase_submit(cfg: Config, ok: bool):
    print(f"\n{'='*60}\n  Phase 5: Submit\n{'='*60}")
    subprocess.run([sys.executable, str(SCRIPTS_DIR/"update_image_list.py"),"--category",cfg.category,"--app-name",cfg.app_name,"--repo-path",cfg.repo_path])
    br = f"add-{cfg.app_name}-{cfg.tag}"
    msg = f"Add {cfg.app_name} {cfg.app_version} on openEuler {cfg.oe_version}\n\nValidation: {'PASSED' if ok else 'partial'}"
    g = lambda *a: subprocess.run(["git","-C",cfg.repo_path]+list(a), capture_output=True, text=True)
    if not g("status","--porcelain").stdout.strip(): print("No changes"); return
    g("checkout","-b",br) if not g("branch","--list",br).stdout.strip() else g("checkout",br)
    g("add",f"{cfg.category}/{cfg.app_name}/",f"{cfg.category}/image-list.yml")
    if cfg.dry_run: print(f"[DRY RUN] {msg[:60]}"); return
    g("commit","-m",msg)
    print(f"Branch: {br} | Tag: {cfg.tag}\nPush: git push -u origin {br}")

# ---- Main ----
def main():
    p = argparse.ArgumentParser(description="openEuler Container Image Workflow")
    p.add_argument("--app-name", required=True); p.add_argument("--app-version", required=True)
    p.add_argument("--source-repo", required=True); p.add_argument("--category", required=True, choices=["Bigdata","AI","Storage","Database","Cloud","HPC","Others","Distroless"])
    p.add_argument("--oe-version", required=True); p.add_argument("--description", default="")
    p.add_argument("--repo-path", default=str(REPO_ROOT)); p.add_argument("--remote-host")
    p.add_argument("--dry-run", action="store_true"); p.add_argument("--skip-validate", action="store_true")
    p.add_argument("--skip-research", action="store_true"); p.add_argument("--skip-generate", action="store_true")
    p.add_argument("--max-qa-rounds", type=int, default=2); p.add_argument("--max-fix-rounds", type=int, default=4)
    a = p.parse_args()
    cfg = Config(app_name=a.app_name, app_version=a.app_version, source_repo=a.source_repo, category=a.category, oe_version=a.oe_version, description=a.description, dry_run=a.dry_run, repo_path=a.repo_path, remote_host=a.remote_host, skip_validate=a.skip_validate, max_qa_rounds=a.max_qa_rounds, max_fix_rounds=a.max_fix_rounds)
    print(f"{'='*60}\n  {cfg.app_name} {cfg.app_version} | {cfg.category} | {cfg.oe_version} | {cfg.tag}")
    if cfg.remote_host: print(f"  Remote: {cfg.remote_host}")
    print(f"{'='*60}")
    research = {}
    if a.skip_research or a.skip_generate: print("\n  [SKIP] Research")
    else:
        research = phase_research(cfg)
        if not research: print("\nERROR: Research failed"); sys.exit(1)
    if a.skip_generate: print("  [SKIP] Generate + QA")
    elif not phase_gen_qa(cfg, research): print("\nERROR: Generate+QA failed"); sys.exit(1)
    ok = False
    if cfg.skip_validate: print("\n  [SKIP] Validate + Fix")
    else: ok = phase_validate_fix(cfg)
    phase_submit(cfg, ok)
    print(f"\n{'='*60}\n  Complete: {cfg.app_name} {cfg.app_version} | {cfg.tag} | Validated: {'YES' if ok else 'partial'}\n{'='*60}")

if __name__ == "__main__":
    main()
