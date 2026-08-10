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

    all_tps = []
    all_qps = []
    for wl, thread_data in rs.items():
        if not isinstance(thread_data, dict):
            continue
        for label, res in thread_data.items():
            if isinstance(res, dict):
                if res.get("tps"):
                    all_tps.append(safe_float(res["tps"]))
                if res.get("qps"):
                    all_qps.append(safe_float(res["qps"]))
    if all_tps:
        summary["avg_tps"] = round(sum(all_tps) / len(all_tps), 2)
        summary["max_tps"] = round(max(all_tps), 2)
    if all_qps:
        summary["avg_qps"] = round(sum(all_qps) / len(all_qps), 2)
        summary["max_qps"] = round(max(all_qps), 2)

    rw_t16 = rs.get("oltp_read_write", {}).get("threads_16", {})
    if isinstance(rw_t16, dict) and rw_t16.get("tps"):
        summary["read_write_tps_t16"] = safe_float(rw_t16["tps"])
    ps_t16 = rs.get("oltp_point_select", {}).get("threads_16", {})
    if isinstance(ps_t16, dict) and ps_t16.get("qps"):
        summary["point_select_qps_t16"] = safe_float(ps_t16["qps"])

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        ts = mresults.get("thread_scaling", {})
        if isinstance(ts, dict):
            t1 = safe_float(ts.get("threads_1", {}).get("qps", 0)) if isinstance(ts.get("threads_1"), dict) else 0
            t64 = safe_float(ts.get("threads_64", {}).get("qps", 0)) if isinstance(ts.get("threads_64"), dict) else 0
            if t1 > 0 and t64 > 0:
                summary["thread_scaling_ratio"] = round(t64 / t1, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    for fname, key in [("benchmark_ob.json", "primary"), ("micro_benchmark.json", "micro")]:
        path = os.path.join(results_dir, fname)
        if os.path.exists(path):
            with open(path) as f:
                data = json.load(f)
            if key == "primary":
                primary = data
            else:
                micro = data
            print(f"[AGGREGATE] Loaded {key} from {path}")

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
        "software": "oceanbase",
        "version": version_info.get("software_version", "4.3.5"),
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
