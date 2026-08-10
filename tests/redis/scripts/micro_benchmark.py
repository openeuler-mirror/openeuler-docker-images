#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
import tempfile
import time
import shutil
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from benchmark_redis import start_redis_server, stop_redis_server, run_redis_benchmark

DATA_SIZES = [64, 256, 1024, 4096]
THREAD_COUNTS = [1, 10, 50, 100, "all"]
PERSISTENCE_MODES = ["none", "aof", "rdb"]


def get_max_threads():
    try:
        return int(os.cpu_count() or 4)
    except Exception:
        return 4


def bench_data_size_sweep(redis_bench_bin, port, iterations):
    results = {}
    for ds in DATA_SIZES:
        label = f"data_size_{ds}"
        r = run_redis_benchmark(redis_bench_bin, port, "SET", 50, data_size=ds, iterations=iterations)
        results[label] = r
        print(f"[MICRO] {label}: QPS={r['qps']}, lat={r['avg_latency_ms']}ms")
    return results


def bench_thread_scaling(redis_bench_bin, port, iterations):
    max_threads = get_max_threads()
    thread_counts = [t if t != "all" else max_threads for t in THREAD_COUNTS]
    results = {}
    for tc in thread_counts:
        label = f"threads_{tc}"
        r = run_redis_benchmark(redis_bench_bin, port, "GET", tc, iterations=iterations)
        results[label] = r
        print(f"[MICRO] {label}: QPS={r['qps']}")
    return results


def bench_persistence_sweep(redis_server_bin, redis_bench_bin, iterations):
    results = {}
    for mode in PERSISTENCE_MODES:
        label = f"persistence_{mode}"
        port = 6391 + PERSISTENCE_MODES.index(mode) * 10 + os.getpid() % 100
        db_path = tempfile.mkdtemp(prefix=f"redis_pers_{mode}_")
        extra_args = []
        if mode == "aof":
            extra_args = ["--appendonly", "yes", "--appendfsync", "everysec"]
        elif mode == "rdb":
            extra_args = ["--save", "1 1"]
        if not start_redis_server(redis_server_bin, port, db_path, extra_args):
            results[label] = {"error": "failed to start server"}
            continue
        try:
            r = run_redis_benchmark(redis_bench_bin, port, "SET", 50, iterations=iterations)
            results[label] = r
            print(f"[MICRO] {label}: QPS={r['qps']}, lat={r['avg_latency_ms']}ms")
        finally:
            stop_redis_server(port)
            shutil.rmtree(db_path, ignore_errors=True)
    return results


def main():
    if len(sys.argv) < 5:
        print("Usage: micro_benchmark.py <redis_server_bin> <redis_bench_bin> <output_file> [iterations]")
        sys.exit(1)
    redis_server_bin = sys.argv[1]
    redis_bench_bin = sys.argv[2]
    output_file = sys.argv[3]
    iterations = int(sys.argv[4]) if len(sys.argv) >= 5 else 1

    if not os.path.exists(redis_server_bin):
        print(f"[MICRO] redis-server not found: {redis_server_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "8.0.0")
    max_threads = get_max_threads()
    port = 6392 + os.getpid() % 1000
    db_path = tempfile.mkdtemp(prefix="redis_micro_")

    print(f"[MICRO] Starting redis-server on port {port}...")
    if not start_redis_server(redis_server_bin, port, db_path):
        sys.exit(1)

    try:
        print("[MICRO] Running data_size_sweep...")
        ds_results = bench_data_size_sweep(redis_bench_bin, port, iterations)

        print("[MICRO] Running thread_scaling...")
        ts_results = bench_thread_scaling(redis_bench_bin, port, iterations)
    finally:
        stop_redis_server(port)
        shutil.rmtree(db_path, ignore_errors=True)

    print("[MICRO] Running persistence_sweep...")
    pers_results = bench_persistence_sweep(redis_server_bin, redis_bench_bin, iterations)

    out = {
        "benchmark": "micro_operations",
        "description": "Redis micro: data size sweep, thread scaling, persistence mode sweep on ARM64",
        "reference": "https://github.com/redis/redis",
        "software": "redis",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "qps": {"unit": "ops/sec", "description": "Queries per second"},
            "latency": {"unit": "ms", "description": "Latency"},
        },
        "parameters": {
            "data_sizes": DATA_SIZES,
            "thread_counts": [str(t) for t in THREAD_COUNTS],
            "max_threads": max_threads,
            "persistence_modes": PERSISTENCE_MODES,
            "iterations": iterations,
        },
        "results": {
            "data_size_sweep": ds_results,
            "thread_scaling": ts_results,
            "persistence_sweep": pers_results,
        },
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[MICRO] Output written to {output_file}")


if __name__ == "__main__":
    main()
