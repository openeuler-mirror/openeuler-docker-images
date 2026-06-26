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


def collect_serialize_qps(ann_data, size_value=100):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        size_sweep = config_res.get("avg_size_sweep", {})
        size_data = size_sweep.get(size_value, {})
        qps = size_data.get("serialize_qps", 0)
        if qps > 0:
            values.append(safe_float(qps))
    return values


def collect_deserialize_qps(ann_data, size_value=100):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        size_sweep = config_res.get("avg_size_sweep", {})
        size_data = size_sweep.get(size_value, {})
        qps = size_data.get("deserialize_qps", 0)
        if qps > 0:
            values.append(safe_float(qps))
    return values


def collect_fidelity(ann_data, size_value=100):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        size_sweep = config_res.get("avg_size_sweep", {})
        size_data = size_sweep.get(size_value, {})
        fid = size_data.get("fidelity", 0)
        if fid > 0:
            values.append(safe_float(fid))
    return values


def collect_latency(ann_data, size_value=100):
    values = []
    summary = ann_data.get("results_summary", {})
    for config_name, config_res in summary.items():
        if "error" in config_res:
            continue
        size_sweep = config_res.get("avg_size_sweep", {})
        size_data = size_sweep.get(size_value, {})
        lat = size_data.get("serialize_latency_us", 0)
        if lat > 0:
            values.append(safe_float(lat))
    return values


def collect_serialize_rate(micro_data):
    ss = micro_data.get("results", {}).get("single_serialize", {})
    return safe_float(ss.get("serialize_qps", 0))


def collect_deserialize_rate(micro_data):
    sd = micro_data.get("results", {}).get("single_deserialize", {})
    return safe_float(sd.get("deserialize_qps", 0))


def main():
    parser = argparse.ArgumentParser(description='Aggregate protobuf benchmark results')
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

    ser_qps_vals = collect_serialize_qps(ann_data, size_value=100)
    if ser_qps_vals:
        summary["avg_serialize_qps_size100"] = round(sum(ser_qps_vals) / len(ser_qps_vals), 2)
        summary["max_serialize_qps_size100"] = round(max(ser_qps_vals), 2)

    deser_qps_vals = collect_deserialize_qps(ann_data, size_value=100)
    if deser_qps_vals:
        summary["avg_deserialize_qps_size100"] = round(sum(deser_qps_vals) / len(deser_qps_vals), 2)
        summary["max_deserialize_qps_size100"] = round(max(deser_qps_vals), 2)

    fid_vals = collect_fidelity(ann_data, size_value=100)
    if fid_vals:
        summary["avg_fidelity_size100"] = round(sum(fid_vals) / len(fid_vals), 4)

    lat_vals = collect_latency(ann_data, size_value=100)
    if lat_vals:
        summary["avg_serialize_latency_us_size100"] = round(sum(lat_vals) / len(lat_vals), 4)
        summary["max_serialize_latency_us_size100"] = round(max(lat_vals), 4)

    ser_rate = collect_serialize_rate(micro_data)
    if ser_rate > 0:
        summary["single_serialize_qps"] = ser_rate

    deser_rate = collect_deserialize_rate(micro_data)
    if deser_rate > 0:
        summary["single_deserialize_qps"] = deser_rate

    mt_ser = micro_data.get("results", {}).get("multithread_serialize", {})
    if mt_ser:
        all_qps = safe_float(mt_ser.get("threads_all", {}).get("avg_qps", 0))
        one_qps = safe_float(mt_ser.get("threads_1", {}).get("avg_qps", 0))
        if all_qps > 0 and one_qps > 0:
            summary["multithread_serialize_scaling_ratio"] = round(all_qps / one_qps, 2)

    mt_deser = micro_data.get("results", {}).get("multithread_deserialize", {})
    if mt_deser:
        all_qps = safe_float(mt_deser.get("threads_all", {}).get("avg_qps", 0))
        one_qps = safe_float(mt_deser.get("threads_1", {}).get("avg_qps", 0))
        if all_qps > 0 and one_qps > 0:
            summary["multithread_deserialize_scaling_ratio"] = round(all_qps / one_qps, 2)

    json_bench = micro_data.get("results", {}).get("json_serialization", {})
    if json_bench:
        bin_qps = safe_float(json_bench.get("binary_serialize", {}).get("avg_qps", 0))
        json_qps_val = safe_float(json_bench.get("json_serialize", {}).get("avg_qps", 0))
        if bin_qps > 0 and json_qps_val > 0:
            summary["binary_vs_json_qps_ratio"] = round(bin_qps / json_qps_val, 2)

    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp", datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'))),
        "environment": version_info,
        "benchmarks": {
            "ann": ann_data,
            "micro": micro_data,
        },
        "summary": summary,
        "software": "protobuf",
        "version": version_info.get("software_version", "35.1"),
    }

    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"[AGGREGATE] Results saved to {args.output}")


if __name__ == '__main__':
    main()
