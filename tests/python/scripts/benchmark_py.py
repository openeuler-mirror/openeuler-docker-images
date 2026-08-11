#!/usr/bin/env python3
import subprocess
import sys
import os
import json
from datetime import datetime, timezone

BENCH_TESTS = "json_dumps,json_loads,nbody,telco,fannkuch,regex_v8,meteor_contest"


def install_pyperformance(python_bin):
    result = subprocess.run(
        [python_bin, "-m", "pip", "install", "--break-system-packages", "pyperformance"],
        capture_output=True, text=True, timeout=300,
    )
    if result.returncode != 0:
        print(f"[BENCHMARK_PY] Failed to install pyperformance: {result.stderr[:500]}")
        return False
    print("[BENCHMARK_PY] pyperformance installed")
    return True


def run_pyperformance(python_bin, output_file, bench_tests=None):
    cmd = [python_bin, "-m", "pyperformance", "run", f"--output={output_file}", "--inherit-environ"]
    if bench_tests:
        cmd.append(f"--tests={bench_tests}")
    print(f"[BENCHMARK_PY] Running pyperformance: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    if result.returncode != 0:
        print(f"[BENCHMARK_PY][DEBUG] pyperformance failed: {result.stderr[:1000]}")
        print(f"[BENCHMARK_PY][DEBUG] stdout: {result.stdout[-1000:]}")
    return result.returncode == 0


def parse_pyperformance_json(json_path):
    with open(json_path) as f:
        data = json.load(f)

    results = {}
    bench_list = data.get("benchmarks", data.get("results", []))
    for bench in bench_list:
        if not isinstance(bench, dict):
            continue
        name = bench.get("name", bench.get("benchmark", "unknown"))
        stats = bench.get("stats", bench.get("result", {}))
        if not isinstance(stats, dict):
            continue
        mean = float(stats.get("mean", stats.get("avg", 0)))
        median = float(stats.get("median", 0))
        stddev = float(stats.get("stddev", 0))
        min_val = float(stats.get("min", 0))
        ops_per_sec = round(1.0 / mean, 2) if mean > 0 else 0
        results[name] = {
            "mean_ms": round(mean * 1000, 4),
            "median_ms": round(median * 1000, 4) if median else 0,
            "stddev_ms": round(stddev * 1000, 4) if stddev else 0,
            "min_ms": round(min_val * 1000, 4) if min_val else 0,
            "ops_per_sec": ops_per_sec,
        }
    return results


def main():
    if len(sys.argv) < 4:
        print("Usage: benchmark_py.py <python_bin> <output_file> [iterations]")
        sys.exit(1)
    python_bin = sys.argv[1]
    output_file = sys.argv[2]
    iterations = int(sys.argv[3]) if len(sys.argv) >= 4 else 1

    if not os.path.exists(python_bin):
        print(f"[BENCHMARK_PY] Python binary not found: {python_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "3.14.7")

    if not install_pyperformance(python_bin):
        sys.exit(1)

    raw_json = output_file.replace(".json", "_raw.json")
    all_results = {}

    for it in range(iterations):
        print(f"[BENCHMARK_PY] Iteration {it+1}/{iterations}")
        if not run_pyperformance(python_bin, raw_json, BENCH_TESTS):
            print(f"[BENCHMARK_PY] Iteration {it+1} failed, trying minimal set...")
            if not run_pyperformance(python_bin, raw_json, "json_dumps,nbody"):
                print("[BENCHMARK_PY] Minimal set also failed")
                continue
        if os.path.exists(raw_json):
            parsed = parse_pyperformance_json(raw_json)
            for name, res in parsed.items():
                if name not in all_results:
                    all_results[name] = res
                else:
                    for key in ["mean_ms", "ops_per_sec"]:
                        vals = [all_results[name][key], res[key]]
                        all_results[name][key] = round(sum(vals) / len(vals), 4)

    out = {
        "benchmark": "pyperformance",
        "description": f"CPython pyperformance benchmark suite ({BENCH_TESTS}) on ARM64",
        "reference": "https://github.com/python/pyperformance",
        "software": "python",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "mean_ms": {"unit": "ms", "description": "Mean execution time"},
            "ops_per_sec": {"unit": "ops/sec", "description": "Operations per second (1/mean)"},
        },
        "parameters": {
            "bench_tests": BENCH_TESTS,
            "iterations": iterations,
        },
        "results_summary": all_results,
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_PY] Output written to {output_file} ({len(all_results)} benchmarks)")
    for name, res in sorted(all_results.items()):
        print(f"  {name}: {res.get('mean_ms', 'N/A')}ms, {res.get('ops_per_sec', 'N/A')} ops/sec")


if __name__ == "__main__":
    main()
