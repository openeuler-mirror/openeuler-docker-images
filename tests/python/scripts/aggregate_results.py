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
    ops_vals = [safe_float(v.get("ops_per_sec", 0)) for v in rs.values()
                if isinstance(v, dict) and v.get("ops_per_sec")]
    if ops_vals:
        summary["avg_ops_per_sec"] = round(sum(ops_vals) / len(ops_vals), 2)
        summary["max_ops_per_sec"] = round(max(ops_vals), 2)
    if rs:
        first_key = next(iter(rs))
        first_val = rs[first_key]
        if isinstance(first_val, dict):
            if first_val.get("ns_per_op"):
                ns_vals = [safe_float(v.get("ns_per_op", 0)) for v in rs.values() if isinstance(v, dict) and v.get("ns_per_op")]
                if ns_vals:
                    summary["avg_ns_per_op"] = round(sum(ns_vals) / len(ns_vals), 2)
                    summary["min_ns_per_op"] = round(min(ns_vals), 2)
            elif first_val.get("mean_ms"):
                mean_vals = [safe_float(v.get("mean_ms", 0)) for v in rs.values() if isinstance(v, dict) and v.get("mean_ms")]
                if mean_vals:
                    summary["avg_mean_ms"] = round(sum(mean_vals) / len(mean_vals), 4)
                    summary["min_mean_ms"] = round(min(mean_vals), 4)
    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        ts = mresults.get("thread_scaling", {})
        if isinstance(ts, dict) and ts:
            first_item = next(iter(ts.values()), {})
            if isinstance(first_item, dict):
                one_label = "threads_1" if "threads_1" in first_item else "cpu_1"
                one = safe_float(first_item.get(one_label, {}).get("ops_per_sec", 0)) if isinstance(first_item.get(one_label), dict) else 0
                if one > 0:
                    max_t = os.cpu_count() or 4
                    all_label = f"threads_all" if "threads_all" in first_item else f"cpu_{max_t}"
                    allq = safe_float(first_item.get(all_label, {}).get("ops_per_sec", 0)) if isinstance(first_item.get(all_label), dict) else 0
                    if allq > 0:
                        summary["thread_scaling_ratio"] = round(allq / one, 2)
    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}
    bench_files = {"benchmark_go.json": "primary", "benchmark_py.json": "primary",
                   "micro_benchmark.json": "micro"}
    for fname, key in bench_files.items():
        path = os.path.join(results_dir, fname)
        if os.path.exists(path):
            with open(path) as f:
                data = json.load(f)
            if key == "primary" and not primary:
                primary = data
            elif key == "micro" and not micro:
                micro = data
            print(f"[AGGREGATE] Loaded {key} from {path}")
    env_path = os.path.join(results_dir, "version_info.json")
    if os.path.exists(env_path):
        with open(env_path) as f:
            version_info = json.load(f)
    summary = compute_summary(primary, micro)
    sw_name = version_info.get("software_name", "unknown")
    sw_ver = version_info.get("software_version", "unknown")
    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp",
                       datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"))),
        "environment": version_info,
        "benchmarks": {"primary": primary, "micro": micro},
        "summary": summary,
        "software": sw_name,
        "version": sw_ver,
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
