#!/usr/bin/env python3
import subprocess
import sys
import os
import json


def run_compression_benchmark(benchmark_bin, output_file, data_size, iterations):
    cmd = [benchmark_bin, "compression", str(iterations), output_file, str(data_size)]
    print(f"[BENCHMARK_COMPRESSION] Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[BENCHMARK_COMPRESSION] Error: {result.stderr}")
        return False
    print(f"[BENCHMARK_COMPRESSION] Output written to {output_file}")
    return True


def main():
    if len(sys.argv) < 3:
        print("Usage: benchmark_compression.py <benchmark_bin> <output_file> [data_size] [iterations]")
        sys.exit(1)

    benchmark_bin = sys.argv[1]
    output_file = sys.argv[2]
    data_size = int(sys.argv[3]) if len(sys.argv) >= 4 else 1048576
    iterations = int(sys.argv[4]) if len(sys.argv) >= 5 else 1

    if not os.path.exists(benchmark_bin):
        print(f"[BENCHMARK_COMPRESSION] Benchmark binary not found: {benchmark_bin}")
        sys.exit(1)

    success = run_compression_benchmark(benchmark_bin, output_file, data_size, iterations)

    if success and os.path.exists(output_file):
        try:
            with open(output_file) as f:
                data = json.load(f)
            print(f"[BENCHMARK_COMPRESSION] Validation: benchmark={data.get('benchmark')}, "
                  f"data_types={list(data.get('results_summary', {}).keys())}")
        except Exception as e:
            print(f"[BENCHMARK_COMPRESSION] Validation failed: {e}")
    else:
        print("[BENCHMARK_COMPRESSION] No output file generated")


if __name__ == "__main__":
    main()
