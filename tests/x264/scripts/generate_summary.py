#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone


def generate_summary(input_json, output_file):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    lines.append("=" * 70)
    lines.append("  x264 Source Build & Performance Benchmark Report")
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
        lines.append(f"  x264 Version:     {env.get('software_version', 'N/A')}")
        lines.append(f"  Python Version:    {env.get('python_version', 'N/A')}")
        lines.append(f"  GCC Version:       {env.get('gcc_version', 'N/A')}")
        lines.append(f"  OS:                {env.get('os', 'N/A')}")
        lines.append(f"  Kernel:           {env.get('kernel', 'N/A')}")
        lines.append("")

    benchmarks = data.get("benchmarks", {})
    primary = benchmarks.get("primary", data.get("primary_benchmark", {}))
    if primary:
        lines.append("  --- H.264 Encode Benchmark (Primary, preset sweep) ---")
        lines.append(f"  Description:       {primary.get('description', 'N/A')}")
        params = primary.get("parameters", {})
        lines.append(f"  Resolution:        {params.get('resolution', 'N/A')}")
        lines.append(f"  Frames:            {params.get('frames', 'N/A')}")
        lines.append(f"  Presets:           {params.get('presets', 'N/A')}")
        lines.append("")
        rs = primary.get("results_summary", {})
        order = ["ultrafast", "fast", "medium", "slow", "veryslow"]
        header = "    {:<12} {:>10} {:>14} {:>10} {:>14}".format("preset", "fps", "bitrate kb/s", "psnr dB", "encode time s")
        lines.append(header)
        lines.append("    " + "-" * (len(header) - 4))
        for preset in order:
            e = rs.get(f"preset_{preset}", {})
            if isinstance(e, dict) and e:
                lines.append("    {:<12} {:>10.2f} {:>14.2f} {:>10.2f} {:>14.4f}".format(
                    preset,
                    e.get("fps", 0) or 0,
                    e.get("bitrate_kbps", 0) or 0,
                    e.get("psnr_db", 0) or 0,
                    e.get("encode_time_s", 0) or 0,
                ))
        lines.append("")

    micro = benchmarks.get("micro", data.get("micro_benchmark", {}))
    if micro:
        lines.append("  --- Micro Benchmarks ---")
        lines.append(f"  Description:       {micro.get('description', 'N/A')}")
        mresults = micro.get("results", {})
        if isinstance(mresults, dict):
            rs2 = mresults.get("resolution_scaling", {})
            if isinstance(rs2, dict) and rs2:
                lines.append("  Resolution scaling (preset medium, 10 frames):")
                for res in sorted(rs2.keys()):
                    e = rs2[res]
                    lines.append(f"    {res:<12}: fps={e.get('fps', 'N/A')}, time={e.get('encode_time_s', 'N/A')}s")
            ts = mresults.get("thread_scaling", {})
            if isinstance(ts, dict) and ts:
                lines.append("  Thread scaling (1280x720, preset medium, 30 frames):")
                for tc in sorted(ts.keys(), key=lambda x: (int(''.join(c for c in x if c.isdigit()) or 0))):
                    e = ts[tc]
                    lines.append(f"    {tc:<14}: fps={e.get('fps', 'N/A')}")
        lines.append("")

    summary = data.get("summary", {})
    if summary:
        lines.append("  --- Overall Summary ---")
        if "avg_fps" in summary:
            lines.append(f"    Avg encode fps:        {summary['avg_fps']}")
        if "max_fps" in summary:
            lines.append(f"    Max encode fps:        {summary['max_fps']} (fastest preset)")
        if "min_fps" in summary:
            lines.append(f"    Min encode fps:        {summary['min_fps']} (slowest preset)")
        if "avg_psnr_db" in summary:
            lines.append(f"    Avg PSNR:              {summary['avg_psnr_db']} dB")
        lines.append("    Per-preset fps:")
        for preset in ["ultrafast", "fast", "medium", "slow", "veryslow"]:
            k = f"preset_{preset}_fps"
            if k in summary:
                lines.append(f"      {preset:<12}: {summary[k]} fps")
        if "res_1280x720_fps" in summary:
            lines.append(f"    720p medium fps:       {summary['res_1280x720_fps']}")
        if "thread_scaling_ratio" in summary:
            lines.append(f"    Thread scaling:        {summary['thread_scaling_ratio']}x")
        lines.append("")

    lines.append("=" * 70)
    lines.append("  Report generated by x264 Source Build & Performance Benchmark Workflow")
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
