#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  RocksDB Source Build & Performance Benchmark Report")
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
        lines.append(f"  RocksDB Version:   {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version:    {env.get('python_version', 'N/A')}")
        lines.append(f"  GCC Version:       {env.get('gcc_version', 'N/A')}")
        lines.append(f"  OS:                {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:           {env.get('kernel', 'N/A')}")
        lines.append("")

    benchmarks = data.get("benchmarks", {})
    primary = benchmarks.get("primary", {})
    if primary:
        lines.append("  --- KV Operations Benchmark (Primary) ---")
        lines.append(f"  Description:       {primary.get('description', 'N/A')}")
        params = primary.get("parameters", {})
        lines.append(f"  Keys:              {params.get('num_keys', 'N/A')}")
        lines.append(f"  Key size:          {params.get('key_size', 'N/A')} bytes")
        lines.append(f"  Value size:        {params.get('value_size', 'N/A')} bytes")
        lines.append(f"  Compression:       {params.get('compression', 'N/A')}")
        lines.append("")
        rs = primary.get("results_summary", {})
        header = "    {:<20} {:>12} {:>14} {:>12}".format("workload", "ops/sec", "latency (us)", "MB/s")
        lines.append(header)
        lines.append("    " + "-" * (len(header) - 4))
        for wl in ["fillseq", "readrandom", "overwrite", "readwhilewriting"]:
            e = rs.get(wl, {})
            if isinstance(e, dict) and e:
                lines.append("    {:<20} {:>12.2f} {:>14.2f} {:>12.2f}".format(
                    wl,
                    e.get("ops_per_sec", 0) or 0,
                    e.get("micros_per_op", 0) or 0,
                    e.get("mb_per_sec", 0) or 0,
                ))
        lines.append("")

    micro = benchmarks.get("micro", {})
    if micro:
        lines.append("  --- Micro Benchmarks ---")
        mresults = micro.get("results", {})
        if isinstance(mresults, dict):
            ts = mresults.get("thread_scaling", {})
            if isinstance(ts, dict) and ts:
                lines.append("  Thread scaling (readrandom):")
                for tc in sorted(ts.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                    e = ts[tc]
                    lines.append(f"    {tc:<14}: ops/sec={e.get('ops_per_sec', 'N/A')}")
            comp = mresults.get("compression_sweep", {})
            if isinstance(comp, dict) and comp:
                lines.append("  Compression type sweep (fillseq):")
                for ct in sorted(comp.keys()):
                    e = comp[ct]
                    lines.append(f"    {ct:<22}: ops/sec={e.get('ops_per_sec', 'N/A')}, MB/s={e.get('mb_per_sec', 'N/A')}")
            vs = mresults.get("value_size_sweep", {})
            if isinstance(vs, dict) and vs:
                lines.append("  Value size sweep (fillseq):")
                for vsl in sorted(vs.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                    e = vs[vsl]
                    lines.append(f"    {vsl:<20}: ops/sec={e.get('ops_per_sec', 'N/A')}, MB/s={e.get('mb_per_sec', 'N/A')}")
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_write_ops_per_sec" in summary:
            lines.append(f"    Avg write ops/sec:    {summary['avg_write_ops_per_sec']}")
        if "max_write_ops_per_sec" in summary:
            lines.append(f"    Max write ops/sec:     {summary['max_write_ops_per_sec']}")
        if "avg_read_ops_per_sec" in summary:
            lines.append(f"    Avg read ops/sec:     {summary['avg_read_ops_per_sec']}")
        if "max_read_ops_per_sec" in summary:
            lines.append(f"    Max read ops/sec:     {summary['max_read_ops_per_sec']}")
        if "thread_scaling_ratio" in summary:
            lines.append(f"    Thread scaling:        {summary['thread_scaling_ratio']}x")
        if "zstd_vs_none_ops_ratio" in summary:
            lines.append(f"    Zstd vs none ops:     {summary['zstd_vs_none_ops_ratio']}x")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by RocksDB Source Build & Performance Benchmark Workflow")
    lines.append("=" * 70)

    summary_text = "\n".join(lines)
    with open(output_file, "w") as f:
        f.write(summary_text)
    print(summary_text)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: generate_summary.py <input_json> <output_file>")
        sys.exit(1)
    generate_summary(sys.argv[1], sys.argv[2])
