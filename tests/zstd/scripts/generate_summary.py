#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone
from collections import defaultdict


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  Zstd Source Build & Performance Benchmark Report")
    lines.append("=" * 70)
    lines.append(f"  Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}")
    lines.append(f"  Test Time: {data.get('test_time', data.get('timestamp', 'N/A'))}")
    lines.append("")

    env = data.get("environment", {})
    if env:
        lines.append("  --- Environment ---")
        lines.append(f"  Architecture:      {env.get('architecture', 'N/A')}")
        lines.append(f"  Model:             {env.get('Model', 'N/A')}")
        lines.append(f"  CPU Model:         {env.get('cpu_model', 'N/A')}")
        lines.append(f"  CPU Cores:         {env.get('cpu_cores', 'N/A')}")
        lines.append(f"  Zstd Version:      {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version:    {env.get('python_version', 'N/A')}")
        lines.append(f"  GCC Version:       {env.get('gcc_version', 'N/A')}")
        lines.append(f"  OS:                {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:            {env.get('kernel', 'N/A')}")
        lines.append("")

    compression = data.get("benchmarks", {}).get("primary", data.get("primary_benchmark", {}))
    if compression:
        lines.append("  --- Compression Benchmark (Primary) ---")
        lines.append(f"  Description:       {compression.get('description', 'N/A')}")
        lines.append(f"  Reference:         {compression.get('reference', 'N/A')}")
        params = compression.get("parameters", {})
        lines.append(f"  Data size:         {params.get('data_size_bytes', 'N/A')} bytes")
        lines.append(f"  Iterations:        {params.get('iterations', 'N/A')}")
        lines.append(f"  Compression levels: {params.get('compression_levels', 'N/A')}")
        lines.append("")

        rs = compression.get("results_summary", {})
        grouped = defaultdict(dict)
        for key, res in rs.items():
            if not isinstance(res, dict):
                continue
            dt = res.get("data_type", key)
            lvl = str(res.get("level", "?"))
            grouped[dt][lvl] = res

        for dt, by_level in grouped.items():
            lines.append(f"  {dt}:")
            for lvl in sorted(by_level.keys(), key=lambda x: int(x) if x.isdigit() else 0):
                res = by_level[lvl]
                lines.append(f"    level {lvl:>2}: "
                             f"compress={res.get('compress_speed_mbs', 'N/A')} MB/s, "
                             f"decompress={res.get('decompress_speed_mbs', 'N/A')} MB/s, "
                             f"ratio={res.get('compression_ratio', 'N/A')}")
            lines.append("")

    micro = data.get("benchmarks", {}).get("micro", data.get("micro_benchmark", {}))
    if micro:
        mparams = micro.get("parameters", {})
        lines.append("  --- Micro Benchmarks ---")
        lines.append(f"  Description:       {micro.get('description', 'N/A')}")
        lines.append(f"  Block sizes:       {mparams.get('block_sizes', 'N/A')}")
        lines.append(f"  Level:             {mparams.get('level', 'N/A')}")
        lines.append(f"  Iterations:        {mparams.get('iterations', 'N/A')}")
        lines.append("")
        results = micro.get("results", {})
        if isinstance(results, dict):
            for test_name, res in results.items():
                if isinstance(res, dict):
                    lines.append(f"  {test_name}:")
                    for k, v in res.items():
                        lines.append(f"    {k}:  {v}")
                    lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_compress_speed_mbs" in summary:
            lines.append(f"    Avg compress speed:    {summary['avg_compress_speed_mbs']} MB/s")
        if "max_compress_speed_mbs" in summary:
            lines.append(f"    Max compress speed:    {summary['max_compress_speed_mbs']} MB/s")
        if "avg_decompress_speed_mbs" in summary:
            lines.append(f"    Avg decompress speed:  {summary['avg_decompress_speed_mbs']} MB/s")
        if "max_decompress_speed_mbs" in summary:
            lines.append(f"    Max decompress speed:  {summary['max_decompress_speed_mbs']} MB/s")
        if "avg_compression_ratio" in summary:
            lines.append(f"    Avg compression ratio: {summary['avg_compression_ratio']}")
        lines.append("    Per-level compress speed / ratio:")
        for lvl in [1, 3, 9, 19]:
            cs_key = f"level{lvl}_avg_compress_speed_mbs"
            cr_key = f"level{lvl}_avg_compression_ratio"
            cs = summary.get(cs_key)
            cr = summary.get(cr_key)
            if cs is not None or cr is not None:
                lines.append(f"      level {lvl:>2}: compress={cs if cs is not None else 'N/A'} MB/s, ratio={cr if cr is not None else 'N/A'}")
        if "micro_avg_compress_speed_mbs" in summary:
            lines.append(f"    Micro avg compress:    {summary['micro_avg_compress_speed_mbs']} MB/s")
        if "multithread_scaling_ratio" in summary:
            lines.append(f"    Multithread scaling:    {summary['multithread_scaling_ratio']}x")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by Zstd Source Build & Performance Benchmark Workflow")
    lines.append("=" * 70)

    summary = "\n".join(lines)
    with open(output_file, "w") as f:
        f.write(summary)
    print(summary)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: generate_summary.py <input_json> <output_file>")
        sys.exit(1)

    input_json = sys.argv[1]
    output_file = sys.argv[2]
    generate_summary(input_json, output_file)
