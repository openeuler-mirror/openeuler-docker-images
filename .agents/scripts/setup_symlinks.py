#!/usr/bin/env python3
"""
Setup script — creates symlinks so Claude Code can discover
the skill and agents from the standard .claude/ directory.

Run from the repository root:
    python3 .agents/scripts/setup_symlinks.py
"""

import os
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENTS_DIR = os.path.join(REPO_ROOT, '.agents')
CLAUDE_SKILLS = os.path.join(REPO_ROOT, '.claude', 'skills', 'openeuler-contrib')
CLAUDE_AGENTS = os.path.join(REPO_ROOT, '.claude', 'agents')

AGENTS = ['oe-researcher', 'oe-generator', 'oe-generator-qa', 'oe-validator', 'oe-fixer']


def main():
    os.makedirs(CLAUDE_SKILLS, exist_ok=True)
    os.makedirs(CLAUDE_AGENTS, exist_ok=True)

    # Symlink skill
    skill_src = os.path.join(AGENTS_DIR, 'SKILL.md')
    skill_dst = os.path.join(CLAUDE_SKILLS, 'SKILL.md')
    _symlink(skill_src, skill_dst, 'skill')

    # Symlink agents
    for agent in AGENTS:
        src = os.path.join(AGENTS_DIR, f'{agent}.md')
        dst = os.path.join(CLAUDE_AGENTS, f'{agent}.md')
        _symlink(src, dst, f'agent {agent}')

    print('\nSetup complete! The following are now available in Claude Code:')
    print(f'  Skill:  /openeuler-contrib')
    for agent in AGENTS:
        print(f'  Agent:  @{agent}')
    print(f'\nVerify with: /agents')


def _symlink(src, dst, label):
    if os.path.exists(dst) or os.path.islink(dst):
        os.remove(dst)
    try:
        os.symlink(src, dst)
        print(f'  Linked {label}: {os.path.relpath(dst, REPO_ROOT)} → .agents/...')
    except OSError as e:
        print(f'  ERROR linking {label}: {e}', file=sys.stderr)


if __name__ == '__main__':
    main()
