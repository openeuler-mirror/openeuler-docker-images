#!/usr/bin/env python3
"""
Setup script — ensures Claude Code can discover the skill and agents.

Since the toolkit now lives directly in .claude/, Claude Code discovers
agents and skills automatically. No symlinks needed.

Run from the repository root:
    python3 .claude/scripts/setup_symlinks.py
"""

import os
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENTS_DIR = os.path.join(REPO_ROOT, '.claude')


def main():
    agents_dir = os.path.join(AGENTS_DIR, 'agents')
    skill_file = os.path.join(AGENTS_DIR, 'SKILL.md')

    if os.path.isdir(agents_dir) and os.path.isfile(skill_file):
        print('openEuler container image contribution toolkit is ready.')
        print(f'  Agents: {agents_dir}')
        print(f'  Skill:  {skill_file}')
        print('\nNo symlinks needed — .claude/ is the canonical location.')
    else:
        print('ERROR: .claude/agents/ or .claude/SKILL.md not found.', file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
