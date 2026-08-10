#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  ScaNN Performance Benchmark Report")
    lines.append("=" * 70)
    lines.append(f"  Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}")
    lines.append(f"  Test Time: {data.get('test_time', data.get('timestamp', 'N/A'))}")
    lines.append("")

    env = data.get("environment", {})
    if env:
        lines.append("  --- Environment ---")
        lines.append(f"  Model:          {env.get('Model', 'N/A')}")
        lines.append(f"  Architecture:   {env.get('architecture', 'N/A')}")
        lines.append(f"  OS:             {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:         {env.get('kernel', 'N/A')}")
        lines.append(f"  CPU Model:      {env.get('cpu_model', 'N/A')}")
        lines.append(f"  CPU Cores:      {env.get('cpu_cores', 'N/A')}")
        lines.append(f"  ScaNN Version:  {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version: {env.get('python_version', 'N/A')}")
        lines.append(f"  NumPy Version:  {env.get('numpy_version', 'N/A')}")
        lines.append("")

    ann = data.get("benchmarks", {}).get("ann", {})
    if ann:
        params = ann.get("parameters", {})
        k_val = params.get("k", 10)
        lines.append("  --- ANN Search Benchmark ---")
        lines.append(f"  Reference:      {ann.get('reference', 'N/A')}")
        lines.append(f"  Dataset:        {params.get('num_vectors', 'N/A')} vectors, {params.get('dimension', 'N/A')} dims, k={k_val}")
        lines.append(f"  leaves_to_search: {params.get('leaves_to_search_values', 'N/A')}")
        lines.append("")
        results = ann.get("results_summary", {})
        for config_name, res in results.items():
            if isinstance(res, dict) and "error" in res:
                lines.append(f"  {config_name}: ERROR - {res['error']}")
            elif isinstance(res, dict):
                lines.append(f"  {config_name}:")
                lines.append(f"    Build time:       {res.get('avg_build_time_s', 'N/A')}s")
                leaves_sweep = res.get("avg_leaves_sweep", {})
                for leaves, leaves_res in sorted(leaves_sweep.items(), key=lambda x: int(x[0]) if str(x[0]).isdigit() else 0):
                    recall_key = f"recall_at_{k_val}"
                    lines.append(f"    leaves={leaves}: QPS={leaves_res.get('qps', 'N/A')}, Recall@{k_val}={leaves_res.get(recall_key, 'N/A')}")
        lines.append("")

    micro = data.get("benchmarks", {}).get("micro", {})
    if micro:
        mparams = micro.get("parameters", {})
        lines.append("  --- Micro Benchmarks ---")
        lines.append(f"  Reference:      {micro.get('reference', 'N/A')}")
        lines.append(f"  Dataset:        {mparams.get('num_vectors', 'N/A')} vectors, {mparams.get('dimension', 'N/A')} dims")
        lines.append("")
        mresults = micro.get("results", {})
        ic = mresults.get("index_construction", {})
        if ic:
            lines.append(f"  Index construction: {ic.get('add_rate_per_sec', 'N/A')} vectors/sec, time={ic.get('avg_time_s', 'N/A')}s")
        mt = mresults.get("batch_search_multithread", {})
        if mt:
            lines.append(f"  Multithread search:")
            for thread_label, mt_res in mt.items():
                lines.append(f"    {thread_label}: QPS={mt_res.get('avg_qps', 'N/A')}, time={mt_res.get('avg_time_s', 'N/A')}s")
        sl = mresults.get("serialization_save_load", {})
        if sl:
            if "error" in sl:
                lines.append(f"  Serialization: N/A ({sl.get('error', '')})")
            else:
                lines.append(f"  Serialization: save={sl.get('avg_save_time_s', 'N/A')}s, load={sl.get('avg_load_time_s', 'N/A')}s, size={sl.get('avg_file_size_bytes', 'N/A')}B")
        sweep = mresults.get("leaves_parameter_sweep", {})
        if sweep:
            lines.append(f"  leaves parameter sweep:")
            for leaves_label, sweep_res in sweep.items():
                lines.append(f"    {leaves_label}: QPS={sweep_res.get('avg_qps', 'N/A')}, Recall={sweep_res.get('avg_recall', 'N/A')}")
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_qps_leaves50" in summary:
            lines.append(f"    Avg QPS (leaves=50): {summary['avg_qps_leaves50']} queries/sec")
        if "max_qps_leaves50" in summary:
            lines.append(f"    Max QPS (leaves=50): {summary['max_qps_leaves50']} queries/sec")
        if "avg_recall_leaves200" in summary:
            lines.append(f"    Avg Recall (leaves=200): {summary['avg_recall_leaves200']}")
        if "avg_latency_us_leaves50" in summary:
            lines.append(f"    Avg Latency (leaves=50): {summary['avg_latency_us_leaves50']} us")
        if "max_latency_us_leaves50" in summary:
            lines.append(f"    Max Latency (leaves=50): {summary['max_latency_us_leaves50']} us")
        if "avg_index_construction_rate" in summary:
            lines.append(f"    Index construction rate: {summary['avg_index_construction_rate']} vectors/sec")
        if "multithread_scaling_ratio" in summary:
            lines.append(f"    Multithread scaling: {summary['multithread_scaling_ratio']}x (all vs 1 thread)")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by ScaNN Performance Benchmark Workflow")
    lines.append("=" * 70)

    summary_text = "\n".join(lines)
    with open(output_file, "w") as f:
        f.write(summary_text)
    print(summary_text)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: generate_summary.py <input_json> <output_file>")
        sys.exit(1)

    input_json = sys.argv[1]
    output_file = sys.argv[2]
    generate_summary(input_json, output_file)
