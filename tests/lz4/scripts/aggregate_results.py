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

    compress_speeds = []
    decompress_speeds = []
    ratios = []
    for name, res in rs.items():
        if not isinstance(res, dict):
            continue
        if res.get("compress_speed_mbs"):
            compress_speeds.append(safe_float(res["compress_speed_mbs"]))
        if res.get("decompress_speed_mbs"):
            decompress_speeds.append(safe_float(res["decompress_speed_mbs"]))
        if res.get("compression_ratio"):
            ratios.append(safe_float(res["compression_ratio"]))

    if compress_speeds:
        summary["avg_compress_speed_mbs"] = round(sum(compress_speeds) / len(compress_speeds), 2)
        summary["max_compress_speed_mbs"] = round(max(compress_speeds), 2)
    if decompress_speeds:
        summary["avg_decompress_speed_mbs"] = round(sum(decompress_speeds) / len(decompress_speeds), 2)
        summary["max_decompress_speed_mbs"] = round(max(decompress_speeds), 2)
    if ratios:
        summary["avg_compression_ratio"] = round(sum(ratios) / len(ratios), 4)

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        bcd = mresults.get("block_compress_decompress", {})
        if isinstance(bcd, dict):
            block_speeds = [safe_float(v.get("compress_speed_mbs", 0)) for v in bcd.values()
                            if isinstance(v, dict) and v.get("compress_speed_mbs")]
            if block_speeds:
                summary["micro_avg_compress_speed_mbs"] = round(sum(block_speeds) / len(block_speeds), 2)
        mt = mresults.get("multithread_scaling", {})
        if isinstance(mt, dict):
            one = safe_float(mt.get("threads_1", {}).get("compress_speed_mbs", 0)) if isinstance(mt.get("threads_1"), dict) else 0
            allq = safe_float(mt.get("threads_all", {}).get("compress_speed_mbs", 0)) if isinstance(mt.get("threads_all"), dict) else 0
            if one > 0 and allq > 0:
                summary["multithread_scaling_ratio"] = round(allq / one, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_compression.json")
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
        "software": "lz4",
        "version": version_info.get("software_version", "1.9.4"),
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
