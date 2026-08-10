#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
import tempfile
import shutil
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from benchmark_kv import run_db_bench, parse_bench_output

THREAD_COUNTS = [1, 2, 4, 8, "all"]
COMPRESSION_TYPES = ["none", "snappy", "zstd"]
VALUE_SIZES = [64, 256, 1024, 4096]
BENCH_RE = re.compile(r"(\w+)\s*:\s*([\d.]+)\s*micros/op\s+([\d.]+)\s+ops/sec")


def get_max_threads():
    try:
        return int(os.cpu_count() or 4)
    except Exception:
        return 4


def bench_thread_scaling(db_bench_bin, num, key_size, value_size, iterations):
    max_threads = get_max_threads()
    thread_counts = [t if t != "all" else max_threads for t in THREAD_COUNTS]
    results = {}
    for tc in thread_counts:
        label = f"threads_{tc}"
        db_path = tempfile.mkdtemp(prefix="rocksdb_mt_")
        try:
            run_db_bench(db_bench_bin, db_path, "fillseq", num, key_size, value_size, threads=1)
            vals = []
            for _ in range(iterations):
                text = run_db_bench(db_bench_bin, db_path, "readrandom", num, key_size, value_size, threads=tc)
                parsed = parse_bench_output(text)
                if "readrandom" in parsed:
                    vals.append(parsed["readrandom"]["ops_per_sec"])
            if vals:
                results[label] = {"ops_per_sec": round(sum(vals) / len(vals), 2)}
            print(f"[MICRO] thread {label}: {results.get(label, {})}")
        finally:
            shutil.rmtree(db_path, ignore_errors=True)
    return results


def bench_compression_sweep(db_bench_bin, num, key_size, value_size, iterations):
    results = {}
    for comp in COMPRESSION_TYPES:
        label = f"compression_{comp}"
        db_path = tempfile.mkdtemp(prefix=f"rocksdb_comp_{comp}_")
        try:
            vals = []
            for _ in range(iterations):
                text = run_db_bench(
                    db_bench_bin, db_path, "fillseq", num, key_size, value_size,
                    threads=1, compression=comp,
                )
                parsed = parse_bench_output(text)
                if "fillseq" in parsed:
                    vals.append(parsed["fillseq"])
            if vals:
                results[label] = {
                    "ops_per_sec": round(sum(v["ops_per_sec"] for v in vals) / len(vals), 2),
                    "mb_per_sec": round(sum(v["mb_per_sec"] for v in vals) / len(vals), 2),
                }
            print(f"[MICRO] {label}: {results.get(label, {})}")
        finally:
            shutil.rmtree(db_path, ignore_errors=True)
    return results


def bench_value_size_sweep(db_bench_bin, num, key_size, iterations):
    results = {}
    for vs in VALUE_SIZES:
        label = f"value_size_{vs}"
        db_path = tempfile.mkdtemp(prefix=f"rocksdb_vs{vs}_")
        try:
            vals = []
            for _ in range(iterations):
                text = run_db_bench(
                    db_bench_bin, db_path, "fillseq", num, key_size, vs, threads=1,
                )
                parsed = parse_bench_output(text)
                if "fillseq" in parsed:
                    vals.append(parsed["fillseq"])
            if vals:
                results[label] = {
                    "ops_per_sec": round(sum(v["ops_per_sec"] for v in vals) / len(vals), 2),
                    "mb_per_sec": round(sum(v["mb_per_sec"] for v in vals) / len(vals), 2),
                }
            print(f"[MICRO] {label}: {results.get(label, {})}")
        finally:
            shutil.rmtree(db_path, ignore_errors=True)
    return results


def main():
    if len(sys.argv) < 6:
        print("Usage: micro_benchmark.py <db_bench_bin> <output_file> <num_keys> <key_size> <value_size> [iterations]")
        sys.exit(1)
    db_bench_bin = sys.argv[1]
    output_file = sys.argv[2]
    num = int(sys.argv[3])
    key_size = int(sys.argv[4])
    value_size = int(sys.argv[5])
    iterations = int(sys.argv[6]) if len(sys.argv) >= 7 else 1

    if not os.path.exists(db_bench_bin):
        print(f"[MICRO] db_bench not found: {db_bench_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "11.8.0")
    max_threads = get_max_threads()

    print("[MICRO] Running thread_scaling...")
    thread_results = bench_thread_scaling(db_bench_bin, num, key_size, value_size, iterations)

    print("[MICRO] Running compression_sweep...")
    comp_results = bench_compression_sweep(db_bench_bin, num, key_size, value_size, iterations)

    print("[MICRO] Running value_size_sweep...")
    vs_results = bench_value_size_sweep(db_bench_bin, num, key_size, iterations)

    out = {
        "benchmark": "micro_operations",
        "description": "RocksDB micro: thread scaling, compression type sweep, value size sweep on ARM64",
        "reference": "https://github.com/facebook/rocksdb",
        "software": "rocksdb",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "ops_per_sec": {"unit": "ops/sec", "description": "Operations per second"},
            "mb_per_sec": {"unit": "MB/s", "description": "Throughput in MB/s"},
        },
        "parameters": {
            "num_keys": num,
            "key_size": key_size,
            "value_size": value_size,
            "max_threads": max_threads,
            "iterations": iterations,
            "thread_counts": [str(t) for t in THREAD_COUNTS],
            "compression_types": COMPRESSION_TYPES,
            "value_sizes": VALUE_SIZES,
        },
        "results": {
            "thread_scaling": thread_results,
            "compression_sweep": comp_results,
            "value_size_sweep": vs_results,
        },
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[MICRO] Output written to {output_file}")


if __name__ == "__main__":
    main()
