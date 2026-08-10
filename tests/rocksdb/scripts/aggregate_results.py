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

    write_ops = []
    read_ops = []
    for name, res in rs.items():
        if not isinstance(res, dict):
            continue
        ops = safe_float(res.get("ops_per_sec", 0)) if res.get("ops_per_sec") else None
        if ops is not None and ops > 0:
            if name in ("fillseq", "overwrite"):
                write_ops.append(ops)
            elif name in ("readrandom", "readwhilewriting"):
                read_ops.append(ops)
            summary[f"{name}_ops_per_sec"] = ops

    if write_ops:
        summary["avg_write_ops_per_sec"] = round(sum(write_ops) / len(write_ops), 2)
        summary["max_write_ops_per_sec"] = round(max(write_ops), 2)
    if read_ops:
        summary["avg_read_ops_per_sec"] = round(sum(read_ops) / len(read_ops), 2)
        summary["max_read_ops_per_sec"] = round(max(read_ops), 2)

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        ts = mresults.get("thread_scaling", {})
        if isinstance(ts, dict):
            one = safe_float(ts.get("threads_1", {}).get("ops_per_sec", 0)) if isinstance(ts.get("threads_1"), dict) else 0
            allq = safe_float(ts.get("threads_all", {}).get("ops_per_sec", 0)) if isinstance(ts.get("threads_all"), dict) else 0
            if one > 0 and allq > 0:
                summary["thread_scaling_ratio"] = round(allq / one, 2)
        comp = mresults.get("compression_sweep", {})
        if isinstance(comp, dict):
            none_ops = safe_float(comp.get("compression_none", {}).get("ops_per_sec", 0)) if isinstance(comp.get("compression_none"), dict) else 0
            zstd_ops = safe_float(comp.get("compression_zstd", {}).get("ops_per_sec", 0)) if isinstance(comp.get("compression_zstd"), dict) else 0
            if none_ops > 0 and zstd_ops > 0:
                summary["zstd_vs_none_ops_ratio"] = round(zstd_ops / none_ops, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_kv.json")
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
        "software": "rocksdb",
        "version": version_info.get("software_version", "11.8.0"),
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
