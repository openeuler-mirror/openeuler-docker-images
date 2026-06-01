# openEuler Container Image Contribution Toolkit

Automated workflow for contributing application container images.

## Architecture
```
.agents/
├── CLAUDE.md              # Format conventions
├── run_workflow.py        # Python orchestrator
├── scripts/               # Helper scripts (validate, generate, submit, setup)
└── agents/                # Agent definitions (researcher, generator, QA, validator, fixer)
```

## Quick Start
```bash
python3 .agents/run_workflow.py --app-name nginx --app-version 1.27.2 --source-repo https://github.com/nginx/nginx --category Others --oe-version 24.03-lts-sp3
```

## Pipeline
Research → Generate+QA(loop) → Validate+Fix(loop) → Submit

## Format Conventions
All rules in `../CLAUDE.md` — the single authoritative reference.

## Agent Setup
```bash
python3 .agents/scripts/setup_symlinks.py
```
