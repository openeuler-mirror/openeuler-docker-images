#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
from datetime import datetime, timezone

WORKLOADS = ["oltp_point_select", "oltp_read_write", "oltp_read_only", "oltp_write_only"]
THREAD_LEVELS = [1, 4, 16, 32]

TPS_RE = re.compile(r"transactions:\s+\d+\s+\(([\d.]+)\s+per sec\.\)")
QPS_RE = re.compile(r"queries:\s+\d+\s+\(([\d.]+)\s+per sec\.\)")
AVG_LAT_RE = re.compile(r"avg:\s+([\d.]+)")
P95_LAT_RE = re.compile(r"95th percentile:\s+([\d.]+)")


def check_observer(host, port, user, password):
    cmd = ["mysql", f"-h{host}", f"-P{port}", f"-u{user}"]
    if password:
        cmd.append(f"-p{password}")
    cmd.extend(["-e", "SELECT 1"])
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
    return result.returncode == 0


def create_database(host, port, user, password, db_name):
    cmd = ["mysql", f"-h{host}", f"-P{port}", f"-u{user}"]
    if password:
        cmd.append(f"-p{password}")
    cmd.extend(["-e", f"CREATE DATABASE IF NOT EXISTS {db_name}"])
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
    return result.returncode == 0


def sysbench_prepare(host, port, user, password, db_name, tables, table_size):
    reset_cmd = ["mysql", f"-h{host}", f"-P{port}", f"-u{user}"]
    if password:
        reset_cmd.append(f"-p{password}")
    reset_cmd.extend(["-e", f"DROP DATABASE IF EXISTS `{db_name}`; CREATE DATABASE `{db_name}`; SET GLOBAL ob_query_timeout=100000000; SET GLOBAL ob_trx_timeout=200000000"])
    subprocess.run(reset_cmd, capture_output=True, text=True, timeout=60)
    cmd = [
        "sysbench", WORKLOADS[0],
        f"--db-driver=mysql",
        f"--mysql-host={host}",
        f"--mysql-port={port}",
        f"--mysql-user={user}",
        f"--mysql-password={password}",
        f"--mysql-db={db_name}",
        f"--tables={tables}",
        f"--table-size={table_size}",
        f"--db-ps-mode=disable",
        "prepare",
    ]
    print(f"[BENCHMARK_OB] Preparing data: {tables} tables × {table_size} rows...")
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    if result.returncode != 0:
        print(f"[BENCHMARK_OB] sysbench prepare failed: {(result.stderr or result.stdout)[:500]}")
        return False
    print("[BENCHMARK_OB] Data prepared.")
    return True


def sysbench_run(host, port, user, password, db_name, workload, threads, tables, table_size, time_sec=60):
    cmd = [
        "sysbench", workload,
        f"--db-driver=mysql",
        f"--mysql-host={host}",
        f"--mysql-port={port}",
        f"--mysql-user={user}",
        f"--mysql-password={password}",
        f"--mysql-db={db_name}",
        f"--tables={tables}",
        f"--table-size={table_size}",
        f"--threads={threads}",
        f"--time={time_sec}",
        f"--db-ps-mode=disable",
        f"--report-interval=1",
        "run",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=time_sec + 120)
    text = result.stdout + "\n" + result.stderr

    tps_m = TPS_RE.search(text)
    qps_m = QPS_RE.search(text)
    avg_m = AVG_LAT_RE.search(text)
    p95_m = P95_LAT_RE.search(text)

    tps = float(tps_m.group(1)) if tps_m else 0.0
    qps = float(qps_m.group(1)) if qps_m else 0.0
    avg_lat = float(avg_m.group(1)) if avg_m else 0.0
    p95 = float(p95_m.group(1)) if p95_m else 0.0

    if tps == 0 and qps == 0:
        print(f"[BENCHMARK_OB][DEBUG] {workload} t={threads} parse failed. Raw output (last 1500):")
        print(text[-1500:])

    return {
        "tps": round(tps, 2),
        "qps": round(qps, 2),
        "avg_latency_ms": round(avg_lat, 2),
        "p95_latency_ms": round(p95, 2),
    }


def main():
    if len(sys.argv) < 9:
        print("Usage: benchmark_ob.py <output_file> <host> <port> <user> <password> <db_name> <tables> <table_size> [iterations] [time_sec]")
        sys.exit(1)
    output_file = sys.argv[1]
    host = sys.argv[2]
    port = sys.argv[3]
    user = sys.argv[4]
    password = sys.argv[5]
    db_name = sys.argv[6]
    tables = int(sys.argv[7])
    table_size = int(sys.argv[8])
    iterations = int(sys.argv[9]) if len(sys.argv) >= 10 else 1
    time_sec = int(sys.argv[10]) if len(sys.argv) >= 11 else 60

    version_str = os.environ.get("SOFTWARE_VERSION", "4.3.5")

    print(f"[BENCHMARK_OB] Checking observer at {host}:{port}...")
    if not check_observer(host, port, user, password):
        print(f"[BENCHMARK_OB] Cannot connect to OceanBase at {host}:{port}. Is observer running?")
        sys.exit(1)

    print(f"[BENCHMARK_OB] Creating database {db_name}...")
    if not create_database(host, port, user, password, db_name):
        print("[BENCHMARK_OB] Failed to create database")
        sys.exit(1)

    if not sysbench_prepare(host, port, user, password, db_name, tables, table_size):
        print("[BENCHMARK_OB] sysbench prepare failed, aborting")
        sys.exit(1)

    results_summary = {}
    for wl in WORKLOADS:
        wl_results = {}
        for threads in THREAD_LEVELS:
            label = f"threads_{threads}"
            print(f"[BENCHMARK_OB] Running {wl} @ threads={threads}...")
            runs = []
            for _ in range(iterations):
                r = sysbench_run(host, port, user, password, db_name, wl, threads, tables, table_size, time_sec)
                runs.append(r)
            avg_tps = round(sum(r["tps"] for r in runs) / len(runs), 2)
            avg_qps = round(sum(r["qps"] for r in runs) / len(runs), 2)
            avg_lat = round(sum(r["avg_latency_ms"] for r in runs) / len(runs), 2)
            avg_p95 = round(sum(r["p95_latency_ms"] for r in runs) / len(runs), 2)
            wl_results[label] = {"tps": avg_tps, "qps": avg_qps, "avg_latency_ms": avg_lat, "p95_latency_ms": avg_p95}
            print(f"  tps={avg_tps}, qps={avg_qps}, p95={avg_p95}ms")
        results_summary[wl] = wl_results

    out = {
        "benchmark": "oltp",
        "description": f"OceanBase OLTP benchmark via sysbench ({tables} tables × {table_size} rows, {time_sec}s per test) on ARM64",
        "reference": "https://github.com/oceanbase/oceanbase",
        "software": "oceanbase",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "tps": {"unit": "trans/sec", "description": "Transactions per second"},
            "qps": {"unit": "queries/sec", "description": "Queries per second"},
            "avg_latency_ms": {"unit": "ms", "description": "Average latency per transaction"},
            "p95_latency_ms": {"unit": "ms", "description": "95th percentile latency"},
        },
        "parameters": {
            "workloads": WORKLOADS,
            "thread_levels": THREAD_LEVELS,
            "tables": tables,
            "table_size": table_size,
            "time_per_test": time_sec,
            "iterations": iterations,
            "connection": f"{user}@{host}:{port}/{db_name}",
        },
        "results_summary": results_summary,
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_OB] Output written to {output_file} ({len(results_summary)} workloads)")


if __name__ == "__main__":
    main()
