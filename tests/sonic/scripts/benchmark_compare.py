#!/usr/bin/env python3
import subprocess
import sys
import os
import json


def run_compare_benchmark(compare_bin, output_file, iterations):
    cmd = [compare_bin, "compare", str(iterations), output_file]
    print(f"[BENCHMARK_COMPARE] Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[BENCHMARK_COMPARE] Error: {result.stderr}")
        return False
    print(f"[BENCHMARK_COMPARE] Output written to {output_file}")
    return True


def main():
    if len(sys.argv) < 3:
        print("Usage: benchmark_compare.py <compare_bin> <output_file> [iterations]")
        sys.exit(1)

    compare_bin = sys.argv[1]
    output_file = sys.argv[2]
    iterations = int(sys.argv[3]) if len(sys.argv) >= 4 else 1

    if not os.path.exists(compare_bin):
        print(f"[BENCHMARK_COMPARE] Compare binary not found: {compare_bin} (skipping head-to-head)")
        sys.exit(0)

    success = run_compare_benchmark(compare_bin, output_file, iterations)

    if success and os.path.exists(output_file):
        try:
            with open(output_file) as f:
                data = json.load(f)
            rs = data.get("results_summary", {})
            libs = sorted(set(v.get("library", "") for v in rs.values() if isinstance(v, dict)))
            print(f"[BENCHMARK_COMPARE] Validation: benchmark={data.get('benchmark')}, "
                  f"libraries={libs}, entries={list(rs.keys())}")
        except Exception as e:
            print(f"[BENCHMARK_COMPARE] Validation failed: {e}")
    else:
        print("[BENCHMARK_COMPARE] No output file generated (compare mode skipped)")


if __name__ == "__main__":
    main()
