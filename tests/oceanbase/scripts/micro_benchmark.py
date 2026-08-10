#!/usr/bin/env python3
import sys
import os
import json
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from benchmark_ob import check_observer, create_database, sysbench_prepare, sysbench_run

THREAD_SCALE_LEVELS = [1, 4, 8, 16, 32, 64]
TABLE_COUNTS = [1, 4, 10]


def bench_thread_scaling(host, port, user, password, db_name, tables, table_size, time_sec, iterations):
    results = {}
    if not sysbench_prepare(host, port, user, password, db_name, tables, table_size):
        return {"error": "sysbench prepare failed"}
    for tc in THREAD_SCALE_LEVELS:
        label = f"threads_{tc}"
        runs = []
        for _ in range(iterations):
            r = sysbench_run(host, port, user, password, db_name, "oltp_point_select", tc, tables, table_size, time_sec)
            runs.append(r)
        avg_qps = round(sum(r["qps"] for r in runs) / len(runs), 2)
        avg_p95 = round(sum(r["p95_latency_ms"] for r in runs) / len(runs), 2)
        results[label] = {"qps": avg_qps, "p95_latency_ms": avg_p95}
        print(f"[MICRO] {label}: QPS={avg_qps}, p95={avg_p95}ms")
    return results


def bench_table_count_sweep(host, port, user, password, table_size, time_sec, iterations):
    results = {}
    for tc in TABLE_COUNTS:
        label = f"tables_{tc}"
        db_name = f"sbtest_tc{tc}"
        if not create_database(host, port, user, password, db_name):
            results[label] = {"error": "create db failed"}
            continue
        if not sysbench_prepare(host, port, user, password, db_name, tc, table_size):
            results[label] = {"error": "prepare failed"}
            continue
        runs = []
        for _ in range(iterations):
            r = sysbench_run(host, port, user, password, db_name, "oltp_point_select", 16, tc, table_size, time_sec)
            runs.append(r)
        avg_qps = round(sum(r["qps"] for r in runs) / len(runs), 2)
        avg_p95 = round(sum(r["p95_latency_ms"] for r in runs) / len(runs), 2)
        results[label] = {"qps": avg_qps, "p95_latency_ms": avg_p95}
        print(f"[MICRO] {label}: QPS={avg_qps}, p95={avg_p95}ms")
    return results


def main():
    if len(sys.argv) < 9:
        print("Usage: micro_benchmark.py <output_file> <host> <port> <user> <password> <tables> <table_size> [iterations] [time_sec]")
        sys.exit(1)
    output_file = sys.argv[1]
    host = sys.argv[2]
    port = sys.argv[3]
    user = sys.argv[4]
    password = sys.argv[5]
    tables = int(sys.argv[6])
    table_size = int(sys.argv[7])
    iterations = int(sys.argv[8]) if len(sys.argv) >= 10 else 1
    time_sec = int(sys.argv[9]) if len(sys.argv) >= 11 else 30

    version_str = os.environ.get("SOFTWARE_VERSION", "4.3.5")

    if not check_observer(host, port, user, password):
        print(f"[MICRO] Cannot connect to OceanBase at {host}:{port}")
        sys.exit(1)

    db_ts = "sbtest_ts"
    if not create_database(host, port, user, password, db_ts):
        print("[MICRO] Failed to create database for thread scaling")
        sys.exit(1)

    print("[MICRO] Running thread_scaling...")
    ts_results = bench_thread_scaling(host, port, user, password, db_ts, tables, table_size, time_sec, iterations)

    print("[MICRO] Running table_count_sweep...")
    tc_results = bench_table_count_sweep(host, port, user, password, table_size, time_sec, iterations)

    out = {
        "benchmark": "micro_operations",
        "description": "OceanBase micro: thread scaling + table count sweep on ARM64",
        "reference": "https://github.com/oceanbase/oceanbase",
        "software": "oceanbase",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "qps": {"unit": "queries/sec", "description": "Queries per second"},
            "p95_latency_ms": {"unit": "ms", "description": "95th percentile latency"},
        },
        "parameters": {
            "thread_scale_levels": THREAD_SCALE_LEVELS,
            "table_counts": TABLE_COUNTS,
            "table_size": table_size,
            "time_per_test": time_sec,
            "iterations": iterations,
        },
        "results": {
            "thread_scaling": ts_results,
            "table_count_sweep": tc_results,
        },
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[MICRO] Output written to {output_file}")


if __name__ == "__main__":
    main()
