#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
from datetime import datetime, timezone

PRESETS = ["ultrafast", "fast", "medium", "slow", "veryslow"]

STATS_RE = re.compile(
    r"encoded\s+(\d+)\s+frames"
    r"(?:,\s+([\d.]+)\s+fps)?"
    r"(?:,\s+([\d.]+)\s+kb/s)?"
    r"(?:,\s+([\d.]+)\s+dB)?"
)


def run_encode(cli_bin, yuv_file, width, height, frames, preset, iterations):
    runs = []
    for _ in range(iterations):
        cmd = [
            cli_bin,
            "--input-res", f"{width}x{height}",
            "--fps", "25",
            "--frames", str(frames),
            "--preset", preset,
            "--psnr",
            "-o", os.devnull,
            yuv_file,
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
        text = result.stderr + "\n" + result.stdout
        m = STATS_RE.search(text)
        fps = float(m.group(2)) if m and m.group(2) else 0.0
        bitrate = float(m.group(3)) if m and m.group(3) else 0.0
        psnr = float(m.group(4)) if m and m.group(4) else 0.0
        enc_frames = int(m.group(1)) if m else 0
        if fps > 0 and enc_frames > 0:
            enc_time = enc_frames / fps
        else:
            enc_time = 0.0
        runs.append({"fps": fps, "bitrate_kbps": bitrate, "psnr_db": psnr,
                      "encode_time_s": enc_time, "frames": enc_frames})
    avg = {}
    for key in ["fps", "bitrate_kbps", "psnr_db", "encode_time_s"]:
        vals = [r[key] for r in runs if r[key] > 0]
        avg[key] = round(sum(vals) / len(vals), 4) if vals else 0.0
    avg["frames"] = runs[0]["frames"] if runs else 0
    return avg


def main():
    if len(sys.argv) < 7:
        print("Usage: benchmark_encode.py <cli_bin> <yuv_file> <width> <height> <frames> <output_json> [iterations]")
        sys.exit(1)
    cli_bin, yuv_file = sys.argv[1], sys.argv[2]
    width, height = int(sys.argv[3]), int(sys.argv[4])
    frames = int(sys.argv[5])
    output_file = sys.argv[6]
    iterations = int(sys.argv[7]) if len(sys.argv) >= 8 else 1

    if not os.path.exists(cli_bin):
        print(f"[BENCHMARK_ENCODE] x264 CLI not found: {cli_bin}")
        sys.exit(1)
    if not os.path.exists(yuv_file):
        print(f"[BENCHMARK_ENCODE] YUV file not found: {yuv_file}")
        sys.exit(1)

    results = {}
    for preset in PRESETS:
        print(f"[BENCHMARK_ENCODE] Running preset {preset}...")
        r = run_encode(cli_bin, yuv_file, width, height, frames, preset, iterations)
        results[f"preset_{preset}"] = {"preset": preset, **r}

    version_str = os.environ.get("SOFTWARE_VERSION", "rolling")
    out = {
        "benchmark": "encode",
        "description": f"x264 H.264 encoding preset sweep ({width}x{height}, {frames} frames) on ARM64",
        "reference": "https://www.videolan.org/developers/x264.html",
        "software": "x264",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "fps": {"unit": "fps", "description": "Encoding frames per second"},
            "bitrate_kbps": {"unit": "kb/s", "description": "Output bitrate"},
            "psnr_db": {"unit": "dB", "description": "Peak signal-to-noise ratio"},
            "encode_time_s": {"unit": "s", "description": "Total encode time"},
        },
        "parameters": {
            "resolution": f"{width}x{height}",
            "frames": frames,
            "iterations": iterations,
            "presets": PRESETS,
        },
        "results_summary": results,
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_ENCODE] Output written to {output_file} ({len(results)} presets)")


if __name__ == "__main__":
    main()
