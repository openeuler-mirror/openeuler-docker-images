#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  Redis Source Build & Performance Benchmark Report")
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
        lines.append(f"  Redis Version:     {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version:    {env.get('python_version', 'N/A')}")
        lines.append(f"  GCC Version:       {env.get('gcc_version', 'N/A')}")
        lines.append(f"  OS:                {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:           {env.get('kernel', 'N/A')}")
        lines.append("")

    benchmarks = data.get("benchmarks", {})
    primary = benchmarks.get("primary", {})
    if primary:
        lines.append("  --- Redis Operations Benchmark (Primary) ---")
        lines.append(f"  Description:       {primary.get('description', 'N/A')}")
        params = primary.get("parameters", {})
        lines.append(f"  Commands:          {params.get('commands', 'N/A')}")
        lines.append(f"  Concurrency:       {params.get('concurrency_levels', 'N/A')}")
        lines.append(f"  Requests/test:     {params.get('num_requests', 'N/A')}")
        lines.append(f"  Persistence:       {params.get('persistence', 'N/A')}")
        lines.append("")
        rs = primary.get("results_summary", {})
        for cmd in sorted(rs.keys()):
            cmd_data = rs[cmd]
            if not isinstance(cmd_data, dict):
                continue
            lines.append(f"  [{cmd}]")
            for conc_label in sorted(cmd_data.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                e = cmd_data[conc_label]
                if isinstance(e, dict) and e:
                    lines.append(f"    {conc_label:<18}: QPS={e.get('qps', 'N/A')}, "
                                 f"avg_lat={e.get('avg_latency_ms', 'N/A')}ms, "
                                 f"p99={e.get('p99_latency_ms', 'N/A')}ms")
            lines.append("")

    micro = benchmarks.get("micro", {})
    if micro:
        lines.append("  --- Micro Benchmarks ---")
        mresults = micro.get("results", {})
        if isinstance(mresults, dict):
            ds = mresults.get("data_size_sweep", {})
            if isinstance(ds, dict) and ds:
                lines.append("  Data size sweep (SET @ c=50):")
                for dsl in sorted(ds.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                    e = ds[dsl]
                    lines.append(f"    {dsl:<18}: QPS={e.get('qps', 'N/A')}, lat={e.get('avg_latency_ms', 'N/A')}ms")
            ts = mresults.get("thread_scaling", {})
            if isinstance(ts, dict) and ts:
                lines.append("  Thread scaling (GET):")
                for tcl in sorted(ts.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                    e = ts[tcl]
                    lines.append(f"    {tcl:<18}: QPS={e.get('qps', 'N/A')}")
            pers = mresults.get("persistence_sweep", {})
            if isinstance(pers, dict) and pers:
                lines.append("  Persistence mode sweep (SET @ c=50):")
                for pl in sorted(pers.keys()):
                    e = pers[pl]
                    if isinstance(e, dict) and e:
                        lines.append(f"    {pl:<22}: QPS={e.get('qps', 'N/A')}, lat={e.get('avg_latency_ms', 'N/A')}ms")
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_qps" in summary:
            lines.append(f"    Avg QPS:              {summary['avg_qps']}")
        if "max_qps" in summary:
            lines.append(f"    Max QPS:              {summary['max_qps']}")
        if "set_qps_c50" in summary:
            lines.append(f"    SET QPS (c=50):       {summary['set_qps_c50']}")
        if "get_qps_c50" in summary:
            lines.append(f"    GET QPS (c=50):       {summary['get_qps_c50']}")
        if "avg_latency_ms" in summary:
            lines.append(f"    Avg latency:          {summary['avg_latency_ms']} ms")
        if "max_p99_latency_ms" in summary:
            lines.append(f"    Max p99 latency:      {summary['max_p99_latency_ms']} ms")
        if "thread_scaling_ratio" in summary:
            lines.append(f"    Thread scaling:       {summary['thread_scaling_ratio']}x")
        if "aof_vs_none_qps_ratio" in summary:
            lines.append(f"    AOF vs none QPS:      {summary['aof_vs_none_qps_ratio']}x")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by Redis Source Build & Performance Benchmark Workflow")
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
