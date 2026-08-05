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
    k = primary.get("parameters", {}).get("k", 10)
    recall_key = f"recall_at_{k}"

    qps_vals = [safe_float(v.get("qps", 0)) for v in rs.values()
                if isinstance(v, dict) and "error" not in v and v.get("qps")]
    if qps_vals:
        summary["avg_qps"] = round(sum(qps_vals) / len(qps_vals), 2)
        summary["max_qps"] = round(max(qps_vals), 2)

    recall_vals = [safe_float(v.get(recall_key, 0)) for v in rs.values()
                   if isinstance(v, dict) and "error" not in v and v.get(recall_key)]
    if recall_vals:
        summary["avg_recall_at_k"] = round(sum(recall_vals) / len(recall_vals), 4)

    lat_vals = [safe_float(v.get("latency_per_query_us", 0)) for v in rs.values()
                if isinstance(v, dict) and "error" not in v and v.get("latency_per_query_us")]
    if lat_vals:
        summary["avg_latency_us"] = round(sum(lat_vals) / len(lat_vals), 2)

    build_vals = [safe_float(v.get("build_time_s", 0)) for v in rs.values()
                  if isinstance(v, dict) and "error" not in v and v.get("build_time_s")]
    if build_vals:
        summary["avg_build_time_s"] = round(sum(build_vals) / len(build_vals), 4)

    mresults = micro.get("results", [])
    if isinstance(mresults, list):
        for t in mresults:
            if not isinstance(t, dict):
                continue
            if t.get("test") == "add_vectors_flat" and t.get("add_rate_per_sec"):
                summary["add_rate_per_sec"] = safe_float(t["add_rate_per_sec"])
            if t.get("test") and "multithread" in str(t.get("test", "")):
                one = safe_float(t.get("threads_1", {}).get("avg_qps", 0)) if isinstance(t.get("threads_1"), dict) else 0
                allq = safe_float(t.get("threads_all", {}).get("avg_qps", 0)) if isinstance(t.get("threads_all"), dict) else 0
                if one > 0 and allq > 0:
                    summary["multithread_scaling_ratio"] = round(allq / one, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_primary.json")
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
        "software": "faiss",
        "version": version_info.get("software_version", "1.14.3"),
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
