#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
from datetime import datetime, timezone

PRESETS = ["ultrafast", "fast", "medium", "slow", "veryslow"]

STATS_RE = re.compile(
    r"encoded\s+(\d+)\s+frames\s+in\s+([\d.]+)s\s+\(([\d.]+)\s+fps\)"
)
PSNR_RE = re.compile(r"PSNR.*?Y:\s*([\d.]+)", re.IGNORECASE)


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
        if not m:
            print(f"[BENCHMARK_ENCODE][DEBUG] preset={preset} returncode={result.returncode}")
            print(f"[BENCHMARK_ENCODE][DEBUG] cmd: {' '.join(cmd)}")
            print(f"[BENCHMARK_ENCODE][DEBUG] raw output (last 2500 chars):")
            print(text[-2500:])
        fps = float(m.group(3)) if m else 0.0
        enc_time = float(m.group(2)) if m else 0.0
        enc_frames = int(m.group(1)) if m else 0
        pm = PSNR_RE.search(text)
        psnr = float(pm.group(1)) if pm else 0.0
        runs.append({"fps": fps, "encode_time_s": enc_time, "psnr_db": psnr})
    avg = {}
    for key in ["fps", "encode_time_s", "psnr_db"]:
        vals = [r[key] for r in runs if r[key] > 0]
        avg[key] = round(sum(vals) / len(vals), 4) if vals else 0.0
    avg["frames"] = runs[0]["frames"] if runs and "frames" in runs[0] else frames
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
        print(f"[BENCHMARK_ENCODE] x265 CLI not found: {cli_bin}")
        sys.exit(1)
    if not os.path.exists(yuv_file):
        print(f"[BENCHMARK_ENCODE] YUV file not found: {yuv_file}")
        sys.exit(1)

    results = {}
    for preset in PRESETS:
        print(f"[BENCHMARK_ENCODE] Running preset {preset}...")
        r = run_encode(cli_bin, yuv_file, width, height, frames, preset, iterations)
        results[f"preset_{preset}"] = {"preset": preset, **r}

    version_str = os.environ.get("SOFTWARE_VERSION", "4.2")
    out = {
        "benchmark": "encode",
        "description": f"x265 H.265/HEVC encoding preset sweep ({width}x{height}, {frames} frames) on ARM64",
        "reference": "https://bitbucket.org/multicoreware/x265_git",
        "software": "x265",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "fps": {"unit": "fps", "description": "Encoding frames per second"},
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
