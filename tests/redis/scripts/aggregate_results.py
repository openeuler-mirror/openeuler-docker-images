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

    all_qps = []
    for cmd, conc_data in rs.items():
        if not isinstance(conc_data, dict):
            continue
        for label, res in conc_data.items():
            if isinstance(res, dict) and res.get("qps"):
                all_qps.append(safe_float(res["qps"]))
    if all_qps:
        summary["avg_qps"] = round(sum(all_qps) / len(all_qps), 2)
        summary["max_qps"] = round(max(all_qps), 2)

    set_c50 = rs.get("SET", {}).get("concurrency_50", {})
    if isinstance(set_c50, dict) and set_c50.get("qps"):
        summary["set_qps_c50"] = safe_float(set_c50["qps"])
    get_c50 = rs.get("GET", {}).get("concurrency_50", {})
    if isinstance(get_c50, dict) and get_c50.get("qps"):
        summary["get_qps_c50"] = safe_float(get_c50["qps"])

    all_lat = []
    for cmd, conc_data in rs.items():
        if not isinstance(conc_data, dict):
            continue
        for label, res in conc_data.items():
            if isinstance(res, dict) and res.get("avg_latency_ms"):
                all_lat.append(safe_float(res["avg_latency_ms"]))
    if all_lat:
        summary["avg_latency_ms"] = round(sum(all_lat) / len(all_lat), 4)
        summary["max_p99_latency_ms"] = round(max(safe_float(r.get("p99_latency_ms", 0))
                                                  for cd in rs.values() if isinstance(cd, dict)
                                                  for r in cd.values() if isinstance(r, dict) and r.get("p99_latency_ms")), 4)

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        ts = mresults.get("thread_scaling", {})
        if isinstance(ts, dict):
            one = safe_float(ts.get("threads_1", {}).get("qps", 0)) if isinstance(ts.get("threads_1"), dict) else 0
            allq_label = f"threads_{get_max_threads()}"
            allq = safe_float(ts.get(allq_label, {}).get("qps", 0)) if isinstance(ts.get(allq_label), dict) else 0
            if one > 0 and allq > 0:
                summary["thread_scaling_ratio"] = round(allq / one, 2)
        pers = mresults.get("persistence_sweep", {})
        if isinstance(pers, dict):
            none_qps = safe_float(pers.get("persistence_none", {}).get("qps", 0)) if isinstance(pers.get("persistence_none"), dict) else 0
            aof_qps = safe_float(pers.get("persistence_aof", {}).get("qps", 0)) if isinstance(pers.get("persistence_aof"), dict) else 0
            if none_qps > 0 and aof_qps > 0:
                summary["aof_vs_none_qps_ratio"] = round(aof_qps / none_qps, 2)

    return summary


def get_max_threads():
    try:
        return int(os.cpu_count() or 4)
    except Exception:
        return 4


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    primary_path = os.path.join(results_dir, "benchmark_redis.json")
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
        "software": "redis",
        "version": version_info.get("software_version", "8.0.0"),
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
