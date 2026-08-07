#!/usr/bin/env python3
import subprocess
import sys
import os
import json


def run_json_benchmark(benchmark_bin, output_file, iterations):
    cmd = [benchmark_bin, "json", str(iterations), output_file]
    print(f"[BENCHMARK_JSON] Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[BENCHMARK_JSON] Error: {result.stderr}")
        return False
    print(f"[BENCHMARK_JSON] Output written to {output_file}")
    return True


def main():
    if len(sys.argv) < 3:
        print("Usage: benchmark_json.py <benchmark_bin> <output_file> [iterations]")
        sys.exit(1)

    benchmark_bin = sys.argv[1]
    output_file = sys.argv[2]
    iterations = int(sys.argv[3]) if len(sys.argv) >= 4 else 1

    if not os.path.exists(benchmark_bin):
        print(f"[BENCHMARK_JSON] Benchmark binary not found: {benchmark_bin}")
        sys.exit(1)

    success = run_json_benchmark(benchmark_bin, output_file, iterations)

    if success and os.path.exists(output_file):
        try:
            with open(output_file) as f:
                data = json.load(f)
            print(f"[BENCHMARK_JSON] Validation: benchmark={data.get('benchmark')}, "
                  f"entries={list(data.get('results_summary', {}).keys())}")
        except Exception as e:
            print(f"[BENCHMARK_JSON] Validation failed: {e}")
    else:
        print("[BENCHMARK_JSON] No output file generated")


if __name__ == "__main__":
    main()
