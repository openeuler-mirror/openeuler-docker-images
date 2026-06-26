#!/usr/bin/env python3
import json
import os
import argparse
from datetime import datetime, timezone


def safe_float(val):
    try:
        return float(val)
    except (ValueError, TypeError):
        return 0.0


def collect_qps_values(ann_data, ef_value=50):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        ef_sweep = config_res.get("avg_ef_sweep", {})
        ef_data = ef_sweep.get(ef_value, {})
        qps = ef_data.get("qps", 0)
        if qps > 0:
            values.append(safe_float(qps))
    return values


def collect_recall_values(ann_data, ef_value=200, k=10):
    values = []
    summary = ann_data.get("results_summary", {})
    recall_key = f"recall_at_{k}"
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        ef_sweep = config_res.get("avg_ef_sweep", {})
        ef_data = ef_sweep.get(ef_value, {})
        recall = ef_data.get(recall_key, 0)
        if recall > 0:
            values.append(safe_float(recall))
    return values


def collect_latency_values(ann_data, ef_value=50):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        ef_sweep = config_res.get("avg_ef_sweep", {})
        ef_data = ef_sweep.get(ef_value, {})
        lat = ef_data.get("latency_per_query_us", 0)
        if lat > 0:
            values.append(safe_float(lat))
    return values


def collect_add_rate(micro_data):
    ic = micro_data.get("results", {}).get("index_construction", {})
    return safe_float(ic.get("add_rate_per_sec", 0))


def main():
    parser = argparse.ArgumentParser(description='Aggregate hnswlib benchmark results')
    parser.add_argument('--results-dir', required=True)
    parser.add_argument('--output', required=True, help='Output results.json file path')
    args = parser.parse_args()

    results_dir = args.results_dir

    version_info = {}
    ann_data = {}
    micro_data = {}

    vi_path = os.path.join(results_dir, 'version_info.json')
    if os.path.exists(vi_path):
        with open(vi_path, 'r') as f:
            version_info = json.load(f)

    ann_path = os.path.join(results_dir, 'benchmark_ann.json')
    if os.path.exists(ann_path):
        with open(ann_path, 'r') as f:
            ann_data = json.load(f)

    micro_path = os.path.join(results_dir, 'micro_benchmark.json')
    if os.path.exists(micro_path):
        with open(micro_path, 'r') as f:
            micro_data = json.load(f)

    summary = {}

    qps_vals = collect_qps_values(ann_data, ef_value=50)
    if qps_vals:
        summary["avg_qps_ef50"] = round(sum(qps_vals) / len(qps_vals), 2)
        summary["max_qps_ef50"] = round(max(qps_vals), 2)

    k_val = ann_data.get("parameters", {}).get("k", 10)
    recall_vals = collect_recall_values(ann_data, ef_value=200, k=k_val)
    if recall_vals:
        summary["avg_recall_ef200"] = round(sum(recall_vals) / len(recall_vals), 4)

    lat_vals = collect_latency_values(ann_data, ef_value=50)
    if lat_vals:
        summary["avg_latency_us_ef50"] = round(sum(lat_vals) / len(lat_vals), 2)
        summary["max_latency_us_ef50"] = round(max(lat_vals), 2)

    add_rate = collect_add_rate(micro_data)
    if add_rate > 0:
        summary["avg_index_construction_rate"] = add_rate

    mt_results = micro_data.get("results", {}).get("batch_search_multithread", {})
    if mt_results:
        all_qps = safe_float(mt_results.get("threads_all", {}).get("avg_qps", 0))
        one_qps = safe_float(mt_results.get("threads_1", {}).get("avg_qps", 0))
        if all_qps > 0 and one_qps > 0:
            summary["multithread_scaling_ratio"] = round(all_qps / one_qps, 2)

    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp", datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'))),
        "environment": version_info,
        "benchmarks": {
            "ann": ann_data,
            "micro": micro_data,
        },
        "summary": summary,
        "software": "hnswlib",
        "version": version_info.get("software_version", "0.8.0"),
    }

    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"[AGGREGATE] Results saved to {args.output}")


if __name__ == '__main__':
    main()
