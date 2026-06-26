#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  protobuf Performance Benchmark Report")
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
        lines.append(f"  protobuf Version: {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version: {env.get('python_version', 'N/A')}")
        lines.append(f"  NumPy Version:  {env.get('numpy_version', 'N/A')}")
        lines.append("")

    ann = data.get("benchmarks", {}).get("ann", {})
    if ann:
        params = ann.get("parameters", {})
        lines.append("  --- Serialization Benchmark ---")
        lines.append(f"  Reference:      {ann.get('reference', 'N/A')}")
        lines.append(f"  Num messages:   {params.get('num_messages', 'N/A')}")
        lines.append(f"  Size values:    {params.get('size_values', 'N/A')}")
        lines.append("")
        results = ann.get("results_summary", {})
        for config_name, res in results.items():
            if "error" in res:
                lines.append(f"  {config_name}: ERROR - {res['error']}")
            else:
                lines.append(f"  {config_name}:")
                lines.append(f"    Serialize time:   {res.get('avg_serialize_time_s', 'N/A')}s")
                lines.append(f"    Deserialize time: {res.get('avg_deserialize_time_s', 'N/A')}s")
                lines.append(f"    Serialized size:  {res.get('avg_serialized_size_bytes', 'N/A')} bytes")
                size_sweep = res.get("avg_size_sweep", {})
                for size_val, sweep_res in sorted(size_sweep.items(), key=lambda x: int(x[0])):
                    lines.append(f"    size={size_val}: SerQPS={sweep_res.get('serialize_qps', 'N/A')}, "
                                 f"DeserQPS={sweep_res.get('deserialize_qps', 'N/A')}, "
                                 f"Fidelity={sweep_res.get('fidelity', 'N/A')}")
        lines.append("")

    micro = data.get("benchmarks", {}).get("micro", {})
    if micro:
        mparams = micro.get("parameters", {})
        lines.append("  --- Micro Benchmarks ---")
        lines.append(f"  Reference:      {micro.get('reference', 'N/A')}")
        lines.append(f"  Num messages:   {mparams.get('num_messages', 'N/A')}")
        lines.append("")
        mresults = micro.get("results", {})
        ss = mresults.get("single_serialize", {})
        if ss:
            lines.append(f"  Single serialize: QPS={ss.get('serialize_qps', 'N/A')}, "
                         f"latency={ss.get('avg_latency_us', 'N/A')}us, time={ss.get('avg_time_s', 'N/A')}s")
        sd = mresults.get("single_deserialize", {})
        if sd:
            lines.append(f"  Single deserialize: QPS={sd.get('deserialize_qps', 'N/A')}, "
                         f"latency={sd.get('avg_latency_us', 'N/A')}us, time={sd.get('avg_time_s', 'N/A')}s")
        mt_ser = mresults.get("multithread_serialize", {})
        if mt_ser:
            lines.append(f"  Multithread serialize:")
            for thread_label, mt_res in mt_ser.items():
                lines.append(f"    {thread_label}: QPS={mt_res.get('avg_qps', 'N/A')}, time={mt_res.get('avg_time_s', 'N/A')}s")
        mt_deser = mresults.get("multithread_deserialize", {})
        if mt_deser:
            lines.append(f"  Multithread deserialize:")
            for thread_label, mt_res in mt_deser.items():
                lines.append(f"    {thread_label}: QPS={mt_res.get('avg_qps', 'N/A')}, time={mt_res.get('avg_time_s', 'N/A')}s")
        json_bench = mresults.get("json_serialization", {})
        if json_bench:
            bin_ser = json_bench.get("binary_serialize", {})
            json_ser = json_bench.get("json_serialize", {})
            lines.append(f"  Binary vs JSON serialization:")
            lines.append(f"    Binary QPS: {bin_ser.get('avg_qps', 'N/A')}, time={bin_ser.get('avg_time_s', 'N/A')}s")
            lines.append(f"    JSON QPS:   {json_ser.get('avg_qps', 'N/A')}, time={json_ser.get('avg_time_s', 'N/A')}s")
            lines.append(f"    Binary size: {json_bench.get('binary_size_bytes', 'N/A')}B, "
                         f"JSON size: {json_bench.get('json_size_bytes', 'N/A')}B, "
                         f"Ratio: {json_bench.get('size_ratio', 'N/A')}x")
        large = mresults.get("large_message", {})
        if large:
            lines.append(f"  Large message: SerQPS={large.get('serialize_qps', 'N/A')}, "
                         f"SerTime={large.get('avg_serialize_time_s', 'N/A')}s, "
                         f"DeserTime={large.get('avg_deserialize_time_s', 'N/A')}s, "
                         f"Size={large.get('avg_message_size_bytes', 'N/A')}B")
        sweep = mresults.get("size_parameter_sweep", {})
        if sweep:
            lines.append(f"  Size parameter sweep:")
            for size_label, sweep_res in sweep.items():
                lines.append(f"    {size_label}: SerQPS={sweep_res.get('avg_serialize_qps', 'N/A')}, "
                             f"DeserQPS={sweep_res.get('avg_deserialize_qps', 'N/A')}")
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_serialize_qps_size100" in summary:
            lines.append(f"    Avg Serialize QPS (size=100): {summary['avg_serialize_qps_size100']} messages/sec")
        if "max_serialize_qps_size100" in summary:
            lines.append(f"    Max Serialize QPS (size=100): {summary['max_serialize_qps_size100']} messages/sec")
        if "avg_deserialize_qps_size100" in summary:
            lines.append(f"    Avg Deserialize QPS (size=100): {summary['avg_deserialize_qps_size100']} messages/sec")
        if "avg_fidelity_size100" in summary:
            lines.append(f"    Avg Fidelity (size=100): {summary['avg_fidelity_size100']}")
        if "single_serialize_qps" in summary:
            lines.append(f"    Single serialize QPS: {summary['single_serialize_qps']} messages/sec")
        if "single_deserialize_qps" in summary:
            lines.append(f"    Single deserialize QPS: {summary['single_deserialize_qps']} messages/sec")
        if "multithread_serialize_scaling_ratio" in summary:
            lines.append(f"    Multithread serialize scaling: {summary['multithread_serialize_scaling_ratio']}x")
        if "multithread_deserialize_scaling_ratio" in summary:
            lines.append(f"    Multithread deserialize scaling: {summary['multithread_deserialize_scaling_ratio']}x")
        if "binary_vs_json_qps_ratio" in summary:
            lines.append(f"    Binary vs JSON QPS ratio: {summary['binary_vs_json_qps_ratio']}x faster")

    lines.append("")
    lines.append("=" * 70)
    lines.append("  Report generated by protobuf Performance Benchmark Workflow")
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
