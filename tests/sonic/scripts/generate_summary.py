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
    lines.append("  sonic-cpp (sonic) Source Build & Performance Benchmark Report")
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
        lines.append(f"  sonic Version:     {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version:    {env.get('python_version', 'N/A')}")
        lines.append(f"  GCC Version:       {env.get('gcc_version', 'N/A')}")
        lines.append(f"  OS:                {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:            {env.get('kernel', 'N/A')}")
        lines.append("")

    benchmarks = data.get("benchmarks", {})

    primary = benchmarks.get("primary", data.get("primary_benchmark", {}))
    if primary:
        lines.append("  --- JSON Benchmark (Primary, sonic only) ---")
        lines.append(f"  Description:       {primary.get('description', 'N/A')}")
        params = primary.get("parameters", {})
        lines.append(f"  Doc sizes:         {params.get('doc_sizes', 'N/A')}")
        lines.append(f"  Iterations:        {params.get('iterations', 'N/A')}")
        lines.append("")
        rs = primary.get("results_summary", {})
        grouped = defaultdict(dict)
        for key, res in rs.items():
            if not isinstance(res, dict):
                continue
            op = res.get("operation", key)
            grouped[op][key] = res
        for op, entries in grouped.items():
            lines.append(f"  [{op}]")
            for k in sorted(entries.keys()):
                e = entries[k]
                lines.append(f"    {k:<20}: qps={e.get('qps', 'N/A')}, "
                             f"throughput={e.get('throughput_mbs', 'N/A')} MB/s, "
                             f"latency={e.get('avg_time_us', 'N/A')} us")
            lines.append("")

    micro = benchmarks.get("micro", data.get("micro_benchmark", {}))
    if micro:
        lines.append("  --- Micro Benchmarks ---")
        lines.append(f"  Description:       {micro.get('description', 'N/A')}")
        mresults = micro.get("results", {})
        if isinstance(mresults, dict):
            pls = mresults.get("parse_latency_by_size", {})
            if isinstance(pls, dict) and pls:
                lines.append("  Parse latency by doc size:")
                for sz in sorted(pls.keys(), key=lambda x: int(x) if x.isdigit() else 0):
                    e = pls[sz]
                    lines.append(f"    {sz:>8} bytes: latency={e.get('avg_time_us', 'N/A')} us, qps={e.get('qps', 'N/A')}")
            mt = mresults.get("multithread_parse", {})
            if isinstance(mt, dict) and mt:
                lines.append("  Multithread parse scaling:")
                for tc in sorted(mt.keys(), key=lambda x: int(''.join(c for c in x if c.isdigit()) or 0)):
                    e = mt[tc]
                    lines.append(f"    {tc:<12}: qps={e.get('qps', 'N/A')}")
        lines.append("")

    compare = benchmarks.get("compare", {})
    if compare:
        lines.append("  --- Head-to-Head Comparison (sonic vs rapidjson/yyjson/nlohmann) ---")
        lines.append(f"  Description:       {compare.get('description', 'N/A')}")
        cparams = compare.get("parameters", {})
        lines.append(f"  Doc size:          {cparams.get('doc_size_bytes', 'N/A')} bytes")
        lines.append(f"  Iterations:        {cparams.get('iterations', 'N/A')}")
        lines.append("")
        crs = compare.get("results_summary", {})
        libs = sorted(set(v.get("library", "") for v in crs.values() if isinstance(v, dict)))
        header = "    {:<12} {:<10} {:>12} {:>14}".format("library", "operation", "qps", "throughput MB/s")
        lines.append(header)
        lines.append("    " + "-" * (len(header) - 4))
        for lib in libs:
            for op in ["parse", "serialize"]:
                key = f"{lib}_{op}"
                e = crs.get(key, {})
                if isinstance(e, dict) and e:
                    lines.append("    {:<12} {:<10} {:>12.2f} {:>14.2f}".format(
                        lib, op, e.get("qps", 0) or 0, e.get("throughput_mbs", 0) or 0))
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_parse_qps" in summary:
            lines.append(f"    Avg parse QPS:           {summary['avg_parse_qps']}")
        if "max_parse_qps" in summary:
            lines.append(f"    Max parse QPS:           {summary['max_parse_qps']}")
        if "avg_serialize_qps" in summary:
            lines.append(f"    Avg serialize QPS:      {summary['avg_serialize_qps']}")
        if "large_parse_throughput_mbs" in summary:
            lines.append(f"    Large parse throughput: {summary['large_parse_throughput_mbs']} MB/s")
        if "multithread_scaling_ratio" in summary:
            lines.append(f"    Multithread scaling:     {summary['multithread_scaling_ratio']}x")
        if "sonic_parse_qps" in summary:
            lines.append(f"    sonic parse QPS:         {summary['sonic_parse_qps']}")
            for comp in ["rapidjson", "yyjson", "nlohmann"]:
                rk = f"sonic_vs_{comp}_parse_ratio"
                if rk in summary:
                    faster_slower = "faster" if summary[rk] >= 1.0 else "slower"
                    lines.append(f"      vs {comp:<11}: {summary[rk]}x ({faster_slower})")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by sonic-cpp Source Build & Performance Benchmark Workflow")
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
