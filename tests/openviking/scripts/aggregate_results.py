#!/usr/bin/env python3
import json
import os
import sys
from datetime import datetime, timezone


def safe_float(val, default=0.0):
    try:
        return float(val)
    except (ValueError, TypeError):
        return default


def compute_summary(primary, micro):
    summary = {}
    rs = primary.get("results_summary", {})

    if "write_ops_per_sec" in rs:
        summary["overall_write_ops_per_sec"] = safe_float(rs.get("write_ops_per_sec"))
    if "write_avg_latency_ms" in rs:
        summary["overall_write_latency_ms"] = safe_float(rs.get("write_avg_latency_ms"))
    if "read_ops_per_sec" in rs:
        summary["overall_read_ops_per_sec"] = safe_float(rs.get("read_ops_per_sec"))
    if "read_avg_latency_ms" in rs:
        summary["overall_read_latency_ms"] = safe_float(rs.get("read_avg_latency_ms"))

    size_keys = ["small_1kb", "medium_64kb", "large_1mb"]
    write_throughputs = []
    read_throughputs = []
    for sk in size_keys:
        s = rs.get(sk, {})
        if isinstance(s, dict):
            if s.get("write_throughput_mbs"):
                write_throughputs.append(safe_float(s["write_throughput_mbs"]))
            if s.get("read_throughput_mbs"):
                read_throughputs.append(safe_float(s["read_throughput_mbs"]))
    if write_throughputs:
        summary["avg_write_throughput_mbs"] = round(sum(write_throughputs) / len(write_throughputs), 2)
    if read_throughputs:
        summary["avg_read_throughput_mbs"] = round(sum(read_throughputs) / len(read_throughputs), 2)

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        mt = mresults.get("multithread_fs_ops", {})
        if isinstance(mt, dict):
            one = safe_float(mt.get("threads_1", {}).get("avg_ops_per_sec", 0)) if isinstance(mt.get("threads_1"), dict) else 0
            allq = safe_float(mt.get("threads_all", {}).get("avg_ops_per_sec", 0)) if isinstance(mt.get("threads_all"), dict) else 0
            if one > 0 and allq > 0:
                summary["multithread_scaling_ratio"] = round(allq / one, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_context.json")
    if os.path.exists(primary_path):
        with open(primary_path) as f:
            primary = json.load(f)
        print(f"[AGGREGATE] Loaded primary from {primary_path}")

    micro_path = os.path.join(results_dir, "micro_benchmark.json")
    if os.path.exists(micro_path):
        with open(micro_path) as f:
            micro = json.load(f)
        print(f"[AGGREGATE] Loaded micro from {micro_path}")

    env_path = os.path.join(results_dir, "version_info.json")
    if os.path.exists(env_path):
        with open(env_path) as f:
            version_info = json.load(f)
        print(f"[AGGREGATE] Loaded environment from {env_path}")

    summary = compute_summary(primary, micro)

    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp",
                       datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"))),
        "environment": version_info,
        "benchmarks": {
            "primary": primary,
            "micro": micro,
        },
        "summary": summary,
        "software": "openviking",
        "version": version_info.get("software_version", "0.4.5"),
    }

    os.makedirs(os.path.dirname(os.path.abspath(output_file)) or ".", exist_ok=True)
    with open(output_file, "w") as f:
        json.dump(result, f, indent=2)
    print(f"[AGGREGATE] Aggregated results saved to {output_file}")
    return result


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: aggregate_results.py <results_dir> <output_file>")
        sys.exit(1)
    aggregate_results(sys.argv[1], sys.argv[2])
