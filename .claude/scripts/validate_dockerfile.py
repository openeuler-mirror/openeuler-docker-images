#!/usr/bin/env python3
"""
Dockerfile Validator — Parses a Dockerfile, extracts all RUN commands,
executes them in a live openEuler BASE container via docker exec,
and reports pass/fail for each command.

Usage:
    python validate_dockerfile.py <dockerfile_path> [options]

Options:
    --base-image IMAGE     Base image to use (default: openeuler/openeuler:latest)
    --container-name NAME  Container name prefix (default: oe-validate)
    --round N              Validation round number (for container naming)
    --skip-cleanup         Don't remove container after validation
    --json-output FILE     Write JSON results to file
    --timeout SECONDS      Timeout per command in seconds (default: 300)
"""

import argparse
import json
import os
import re
import subprocess
import sys
import time
import uuid


def parse_dockerfile(filepath: str) -> list[dict]:
    """
    Parse a Dockerfile and extract all RUN commands.

    Each returned dict has:
        - line: starting line number in the file
        - raw: raw text of the RUN instruction
        - commands: list of individual shell commands (split by &&)
        - is_user_group: True if this RUN only does useradd/groupadd
    """
    if not os.path.exists(filepath):
        print(f"ERROR: Dockerfile not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    with open(filepath) as f:
        lines = f.readlines()

    run_blocks = []
    current_block = None

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        # Skip comments and empty lines
        if not stripped or stripped.startswith('#'):
            continue

        if stripped.upper().startswith('RUN '):
            # New RUN block
            if current_block:
                run_blocks.append(current_block)
            content = stripped[4:]  # Remove "RUN " prefix
            # Check if this continues on next line
            continues = content.rstrip().endswith('\\')
            current_block = {
                'line': i,
                'raw_lines': [content],
                'continues': continues,
            }
        elif current_block and current_block['continues']:
            # Continuation of previous RUN
            current_block['raw_lines'].append(stripped)
            current_block['continues'] = stripped.rstrip().endswith('\\')

    if current_block:
        run_blocks.append(current_block)

    # Process each block
    result = []
    for block in run_blocks:
        full_text = '\n'.join(block['raw_lines'])
        # Remove line continuation backslashes
        full_text = re.sub(r'\\\s*\n', ' ', full_text)
        full_text = full_text.strip()

        # Split by && but respect quoted strings
        commands = _split_by_and(full_text)

        # Detect user/group management only blocks
        is_user_group = all(
            re.search(r'(useradd|groupadd|groupmod|usermod)', cmd)
            for cmd in commands
        )

        result.append({
            'line': block['line'],
            'raw': full_text,
            'commands': commands,
            'is_user_group': is_user_group,
        })

    return result


def _split_by_and(text: str) -> list[str]:
    """Split shell command text by &&, respecting quotes."""
    commands = []
    current = []
    in_single = False
    in_double = False
    i = 0

    while i < len(text):
        ch = text[i]
        if ch == "'" and not in_double:
            in_single = not in_single
            current.append(ch)
        elif ch == '"' and not in_single:
            in_double = not in_double
            current.append(ch)
        elif ch == '&' and not in_single and not in_double:
            if i + 1 < len(text) and text[i + 1] == '&':
                # Found &&
                cmd = ''.join(current).strip()
                if cmd:
                    commands.append(cmd)
                current = []
                i += 1  # skip second &
            else:
                current.append(ch)
        else:
            current.append(ch)
        i += 1

    remaining = ''.join(current).strip()
    if remaining:
        commands.append(remaining)

    return commands


def run_in_container(container_name: str, command: str, timeout: int = 300) -> dict:
    """Execute a command inside a running Docker container."""
    full_cmd = ['docker', 'exec', container_name, 'bash', '-c', command]
    start = time.time()
    try:
        proc = subprocess.run(
            full_cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        elapsed = time.time() - start
        return {
            'success': proc.returncode == 0,
            'exit_code': proc.returncode,
            'stdout': proc.stdout[-2000:],  # Keep last 2000 chars
            'stderr': proc.stderr[-2000:],
            'elapsed': round(elapsed, 2),
        }
    except subprocess.TimeoutExpired:
        return {
            'success': False,
            'exit_code': -1,
            'stdout': '',
            'stderr': f'Command timed out after {timeout}s',
            'elapsed': timeout,
        }


def container_exists(name: str) -> bool:
    """Check if a container with the given name exists."""
    proc = subprocess.run(
        ['docker', 'ps', '-a', '--format', '{{.Names}}'],
        capture_output=True, text=True,
    )
    return name in proc.stdout.splitlines()


def validate_dockerfile(
    dockerfile_path: str,
    base_image: str = 'openeuler/openeuler:latest',
    container_name: str = 'oe-validate',
    timeout: int = 300,
    skip_cleanup: bool = False,
) -> dict:
    """
    Main validation routine.

    Returns a dict with:
        success, total_commands, passed, failed, failures[], warnings[]
    """
    uid = uuid.uuid4().hex[:8]
    container_name = f'{container_name}-{uid}'

    # Step 1: Parse Dockerfile
    print(f'[1/5] Parsing Dockerfile: {dockerfile_path}')
    run_blocks = parse_dockerfile(dockerfile_path)
    total_commands = sum(len(b['commands']) for b in run_blocks)
    print(f'       Found {len(run_blocks)} RUN blocks with {total_commands} total commands')

    # Step 2: Pull base image
    print(f'[2/5] Pulling base image: {base_image}')
    pull_result = subprocess.run(
        ['docker', 'pull', base_image],
        capture_output=True, text=True,
    )
    if pull_result.returncode != 0:
        print(f'       WARNING: pull had issues (may already be cached)')
        print(f'       {pull_result.stderr[-500:]}')

    # Step 3: Start container
    print(f'[3/5] Starting container: {container_name}')
    # Remove old container if exists
    if container_exists(container_name):
        subprocess.run(['docker', 'rm', '-f', container_name],
                      capture_output=True)

    run_result = subprocess.run(
        ['docker', 'run', '-d', '--name', container_name,
         base_image, 'tail', '-f', '/dev/null'],
        capture_output=True, text=True,
    )
    if run_result.returncode != 0:
        print(f'       ERROR: Failed to start container: {run_result.stderr}')
        return {
            'success': False,
            'total_commands': total_commands,
            'passed': 0,
            'failed': total_commands,
            'failures': [{
                'command': 'docker run',
                'error': run_result.stderr.strip(),
                'suggestion': 'Check that Docker is running and the base image is valid',
            }],
            'warnings': [],
        }
    container_id = run_result.stdout.strip()[:12]
    print(f'       Container ID: {container_id}')

    # Allow container to fully start
    time.sleep(2)

    # Step 4: Execute each command
    print(f'[4/5] Executing commands in container...')
    failures = []
    warnings = []
    passed = 0
    cmd_index = 0

    for block in run_blocks:
        for cmd in block['commands']:
            cmd_index += 1
            # Skip pure user/group management commands (run them but don't fail on them)
            if block['is_user_group']:
                print(f'       [{cmd_index}/{total_commands}] SKIP (user/group): {cmd[:80]}...')
                result = run_in_container(container_name, cmd, timeout)
                if not result['success']:
                    warnings.append(f'User/group cmd failed (non-fatal): {cmd[:80]}... -> {result["stderr"][:200]}')
                else:
                    passed += 1
                continue

            print(f'       [{cmd_index}/{total_commands}] RUN: {cmd[:100]}...')
            result = run_in_container(container_name, cmd, timeout)

            if result['success']:
                passed += 1
                print(f'             PASS ({result["elapsed"]}s)')
            else:
                print(f'             FAIL ({result["elapsed"]}s)')
                # Extract meaningful error
                error_text = result['stderr'] or result['stdout']
                error_lines = [l for l in error_text.splitlines() if l.strip()]
                error_summary = '\n'.join(error_lines[-10:]) if error_lines else 'Unknown error'

                # Generate fix suggestion
                suggestion = _suggest_fix(cmd, error_text)

                failures.append({
                    'command': cmd,
                    'line': block['line'],
                    'error': error_summary,
                    'exit_code': result['exit_code'],
                    'suggestion': suggestion,
                })

    # Step 5: Cleanup
    if not skip_cleanup:
        print(f'[5/5] Cleaning up container: {container_name}')
        subprocess.run(['docker', 'rm', '-f', container_name],
                      capture_output=True)
    else:
        print(f'[5/5] Container kept for debugging: {container_name}')
        print(f'       Remove with: docker rm -f {container_name}')

    success = len(failures) == 0
    status = 'ALL PASSED' if success else f'{len(failures)} FAILURES'
    print(f'\n{"="*60}')
    print(f'  Result: {status}')
    print(f'  Total:  {total_commands}  |  Passed: {passed}  |  Failed: {len(failures)}')
    print(f'{"="*60}')

    return {
        'success': success,
        'total_commands': total_commands,
        'passed': passed,
        'failed': len(failures),
        'failures': failures,
        'warnings': warnings,
        'container_name': container_name if skip_cleanup else None,
    }


def _suggest_fix(command: str, error_text: str) -> str:
    """Generate a fix suggestion based on common error patterns."""
    error_lower = error_text.lower()

    if 'command not found' in error_lower:
        # Extract the command name
        match = re.search(r'(\w+): command not found', error_text)
        if match:
            cmd_name = match.group(1)
            return f"Package providing '{cmd_name}' is not installed. Add it to yum install list. Try: yum search {cmd_name}"

    if 'no such file or directory' in error_lower:
        match = re.search(r'([/\w.]+): [Nn]o such file', error_text)
        if match:
            path = match.group(1)
            return f"File or directory '{path}' not found. Check if prior steps created it correctly."

    if 'cannot find' in error_lower or 'unable to locate' in error_lower:
        return 'Package or file not found. Check if the package name is correct for openEuler (RPM-based). Use yum search to find the correct name.'

    if 'permission denied' in error_lower:
        return 'Permission denied. Add chmod or run with appropriate user context.'

    if 'no package' in error_lower and 'available' in error_lower:
        match = re.search(r'[Nn]o package (\S+) available', error_text)
        if match:
            pkg = match.group(1)
            return f"Package '{pkg}' not available in openEuler repos. Check alternative package names (e.g., -devel instead of -dev) or use EPOL repo."

    if 'wget' in error_lower and ('unable to resolve' in error_lower or 'connection refused' in error_lower):
        return 'Network/DNS issue in container. Check DNS configuration or use a different download URL.'

    if 'gcc' in error_lower and 'error' in error_lower:
        return 'C/C++ compilation error. Check for missing -devel packages or incompatible compiler flags.'

    if 'cmake' in error_lower and 'error' in error_lower:
        return 'CMake configuration error. Check for missing dependencies or incorrect CMake flags.'

    if 'make' in error_lower and 'error' in error_lower:
        return 'Build error. Check build dependencies and compiler flags.'

    # Generic
    return 'Review the error output. Common openEuler issues: -dev packages are named -devel, use yum not apt, check package name spelling.'


def main():
    parser = argparse.ArgumentParser(description='Validate Dockerfile in live container')
    parser.add_argument('dockerfile', help='Path to Dockerfile')
    parser.add_argument('--base-image', default='openeuler/openeuler:latest',
                       help='Base image for container')
    parser.add_argument('--container-name', default='oe-validate',
                       help='Container name prefix')
    parser.add_argument('--round', type=int, default=1,
                       help='Validation round number')
    parser.add_argument('--skip-cleanup', action='store_true',
                       help='Keep container after validation')
    parser.add_argument('--json-output', help='Write JSON results to file')
    parser.add_argument('--timeout', type=int, default=300,
                       help='Timeout per command in seconds')

    args = parser.parse_args()

    result = validate_dockerfile(
        dockerfile_path=args.dockerfile,
        base_image=args.base_image,
        container_name=f'{args.container_name}-r{args.round}',
        timeout=args.timeout,
        skip_cleanup=args.skip_cleanup,
    )

    if args.json_output:
        with open(args.json_output, 'w') as f:
            json.dump(result, f, indent=2)
        print(f'Results written to: {args.json_output}')

    sys.exit(0 if result['success'] else 1)


if __name__ == '__main__':
    main()
