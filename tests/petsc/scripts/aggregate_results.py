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

    timed_ops = []
    for name, res in rs.items():
        if not isinstance(res, dict):
            continue
        if res.get("avg") is not None:
            timed_ops.append((name, safe_float(res["avg"])))

    if timed_ops:
        summary["operation_count"] = len(timed_ops)
        avgs = [v for _, v in timed_ops]
        summary["avg_time_s"] = round(sum(avgs) / len(avgs), 4)
        summary["min_time_s"] = round(min(avgs), 4)
        summary["max_time_s"] = round(max(avgs), 4)

    return summary


def aggregate_results(results_dir, output_file):
    os.makedirs(results_dir, exist_ok=True)

    primary = {}
    micro = {}
    version_info = {}

    for fname in ("benchmark_ann.json", "benchmark_kv.json", "benchmark_generic.json"):
        primary_path = os.path.join(results_dir, fname)
        if os.path.exists(primary_path):
            with open(primary_path) as f:
                primary = json.load(f)
            print(f"[AGGREGATE] Loaded primary from {primary_path}")
            break

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
        "software": "petsc",
        "version": version_info.get("software_version", "3.25.3"),
    }

    try:
        os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
        with open(output_file, "w") as f:
            json.dump(result, f, indent=2)
        print(f"[AGGREGATE] Aggregated results saved to {output_file}")
    except Exception as e:
        print(f"[AGGREGATE] Failed to write {output_file}: {e}")
    return result


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: aggregate_results.py <results_dir> <output_file>")
        sys.exit(1)
    aggregate_results(sys.argv[1], sys.argv[2])
