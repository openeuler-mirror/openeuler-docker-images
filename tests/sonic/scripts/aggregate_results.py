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


def compute_summary(primary, micro, compare):
    summary = {}
    rs = primary.get("results_summary", {})

    parse_qps = [safe_float(v.get("qps", 0)) for v in rs.values()
                 if isinstance(v, dict) and v.get("operation") == "parse" and v.get("qps")]
    ser_qps = [safe_float(v.get("qps", 0)) for v in rs.values()
               if isinstance(v, dict) and v.get("operation") == "serialize" and v.get("qps")]
    parse_thr = [safe_float(v.get("throughput_mbs", 0)) for v in rs.values()
                 if isinstance(v, dict) and v.get("operation") == "parse" and v.get("throughput_mbs")]

    if parse_qps:
        summary["avg_parse_qps"] = round(sum(parse_qps) / len(parse_qps), 2)
        summary["max_parse_qps"] = round(max(parse_qps), 2)
    if ser_qps:
        summary["avg_serialize_qps"] = round(sum(ser_qps) / len(ser_qps), 2)
        summary["max_serialize_qps"] = round(max(ser_qps), 2)
    if parse_thr:
        summary["avg_parse_throughput_mbs"] = round(sum(parse_thr) / len(parse_thr), 2)

    large_parse = rs.get("parse_large", {})
    if isinstance(large_parse, dict) and large_parse.get("throughput_mbs"):
        summary["large_parse_throughput_mbs"] = safe_float(large_parse["throughput_mbs"])
    large_ser = rs.get("serialize_large", {})
    if isinstance(large_ser, dict) and large_ser.get("throughput_mbs"):
        summary["large_serialize_throughput_mbs"] = safe_float(large_ser["throughput_mbs"])

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        mt = mresults.get("multithread_parse", {})
        if isinstance(mt, dict):
            one = safe_float(mt.get("threads_1", {}).get("qps", 0)) if isinstance(mt.get("threads_1"), dict) else 0
            allq = safe_float(mt.get("threads_all", {}).get("qps", 0)) if isinstance(mt.get("threads_all"), dict) else 0
            if one > 0 and allq > 0:
                summary["multithread_scaling_ratio"] = round(allq / one, 2)

    crs = compare.get("results_summary", {})
    sonic_parse = safe_float(crs.get("sonic_parse", {}).get("qps", 0)) if isinstance(crs.get("sonic_parse"), dict) else 0
    if sonic_parse > 0:
        summary["sonic_parse_qps"] = round(sonic_parse, 2)
        for comp in ["rapidjson", "yyjson", "nlohmann"]:
            comp_key = f"{comp}_parse"
            comp_qps = safe_float(crs.get(comp_key, {}).get("qps", 0)) if isinstance(crs.get(comp_key), dict) else 0
            if comp_qps > 0:
                summary[f"sonic_vs_{comp}_parse_ratio"] = round(sonic_parse / comp_qps, 2)
        sonic_ser = safe_float(crs.get("sonic_serialize", {}).get("qps", 0)) if isinstance(crs.get("sonic_serialize"), dict) else 0
        if sonic_ser > 0:
            summary["sonic_serialize_qps"] = round(sonic_ser, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    compare = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_json.json")
    if os.path.exists(primary_path):
        with open(primary_path) as f:
            primary = json.load(f)
        print(f"[AGGREGATE] Loaded primary from {primary_path}")

    micro_path = os.path.join(results_dir, "micro_benchmark.json")
    if os.path.exists(micro_path):
        with open(micro_path) as f:
            micro = json.load(f)
        print(f"[AGGREGATE] Loaded micro from {micro_path}")

    compare_path = os.path.join(results_dir, "benchmark_compare.json")
    if os.path.exists(compare_path):
        with open(compare_path) as f:
            compare = json.load(f)
        print(f"[AGGREGATE] Loaded compare from {compare_path}")
    else:
        print("[AGGREGATE] No benchmark_compare.json (head-to-head mode skipped)")

    env_path = os.path.join(results_dir, "version_info.json")
    if os.path.exists(env_path):
        with open(env_path) as f:
            version_info = json.load(f)
        print(f"[AGGREGATE] Loaded environment from {env_path}")

    summary = compute_summary(primary, micro, compare)

    benchmarks = {
        "primary": primary,
        "micro": micro,
    }
    if compare:
        benchmarks["compare"] = compare

    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp",
                       datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"))),
        "environment": version_info,
        "benchmarks": benchmarks,
        "summary": summary,
        "software": "sonic",
        "version": version_info.get("software_version", "1.0.2"),
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
