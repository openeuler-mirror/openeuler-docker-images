#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
import tempfile
import shutil
from datetime import datetime, timezone

WORKLOADS = ["fillseq", "readrandom", "overwrite", "readwhilewriting"]

BENCH_RE = re.compile(
    r"(\w+)\s*:\s*([\d.]+)\s*micros/op\s+([\d.]+)\s+ops/sec"
    r"(?:.*?([\d.]+)\s*MB/s)?"
)


def run_db_bench(db_bench_bin, db_path, benchmarks, num, key_size, value_size,
                 threads=1, compression="snappy", extra_args=None):
    cmd = [
        db_bench_bin,
        "--db=" + db_path,
        "--benchmarks=" + benchmarks,
        "--num=" + str(num),
        "--key_size=" + str(key_size),
        "--value_size=" + str(value_size),
        "--threads=" + str(threads),
        "--compression_type=" + compression,
        "--statistics=0",
        "--stats_dump_period_sec=0",
    ]
    if extra_args:
        cmd.extend(extra_args)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    return result.stdout + "\n" + result.stderr


def parse_bench_output(text):
    results = {}
    for m in BENCH_RE.finditer(text):
        name = m.group(1)
        micros = float(m.group(2))
        ops = float(m.group(3))
        mbs = float(m.group(4)) if m.group(4) else 0.0
        results[name] = {
            "ops_per_sec": round(ops, 2),
            "micros_per_op": round(micros, 2),
            "mb_per_sec": round(mbs, 2),
        }
    return results


def main():
    if len(sys.argv) < 7:
        print("Usage: benchmark_kv.py <db_bench_bin> <output_file> <num_keys> <key_size> <value_size> [iterations]")
        sys.exit(1)
    db_bench_bin = sys.argv[1]
    output_file = sys.argv[2]
    num = int(sys.argv[3])
    key_size = int(sys.argv[4])
    value_size = int(sys.argv[5])
    iterations = int(sys.argv[6]) if len(sys.argv) >= 7 else 1

    if not os.path.exists(db_bench_bin):
        print(f"[BENCHMARK_KV] db_bench not found: {db_bench_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "11.8.0")
    all_runs = []

    for it in range(iterations):
        db_path = tempfile.mkdtemp(prefix="rocksdb_bench_")
        try:
            print(f"[BENCHMARK_KV] Iteration {it+1}/{iterations}, DB: {db_path}")
            text = run_db_bench(
                db_bench_bin, db_path,
                ",".join(WORKLOADS),
                num, key_size, value_size,
                threads=1, compression="snappy",
            )
            if not text.strip():
                print(f"[BENCHMARK_KV][DEBUG] empty output, returncode may indicate error")
                print(f"[BENCHMARK_KV][DEBUG] raw output (last 2000 chars):")
                print(text[-2000:])
            parsed = parse_bench_output(text)
            all_runs.append(parsed)
        finally:
            shutil.rmtree(db_path, ignore_errors=True)

    results_summary = {}
    for wl in WORKLOADS:
        vals = [r[wl] for r in all_runs if wl in r]
        if vals:
            results_summary[wl] = {
                "ops_per_sec": round(sum(v["ops_per_sec"] for v in vals) / len(vals), 2),
                "micros_per_op": round(sum(v["micros_per_op"] for v in vals) / len(vals), 2),
                "mb_per_sec": round(sum(v["mb_per_sec"] for v in vals) / len(vals), 2),
            }
        if not vals:
            print(f"[BENCHMARK_KV][DEBUG] workload {wl} not found in output")

    out = {
        "benchmark": "kv_ops",
        "description": f"RocksDB LSM-tree KV operations benchmark ({num} keys, {key_size}B key, {value_size}B value, snappy compression) on ARM64",
        "reference": "https://github.com/facebook/rocksdb",
        "software": "rocksdb",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "ops_per_sec": {"unit": "ops/sec", "description": "Operations per second"},
            "micros_per_op": {"unit": "us", "description": "Microseconds per operation"},
            "mb_per_sec": {"unit": "MB/s", "description": "Throughput in megabytes per second"},
        },
        "parameters": {
            "num_keys": num,
            "key_size": key_size,
            "value_size": value_size,
            "compression": "snappy",
            "threads": 1,
            "iterations": iterations,
            "workloads": WORKLOADS,
        },
        "results_summary": results_summary,
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_KV] Output written to {output_file} ({len(results_summary)} workloads)")
    for wl, res in results_summary.items():
        print(f"[BENCHMARK_KV] {wl}: ops/sec={res['ops_per_sec']}, latency={res['micros_per_op']}us, throughput={res['mb_per_sec']}MB/s")


if __name__ == "__main__":
    main()
