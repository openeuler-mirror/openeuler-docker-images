#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
import tempfile
import shutil
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_yuv import generate_yuv

STATS_RE = re.compile(
    r"encoded\s+(\d+)\s+frames\s+in\s+([\d.]+)s\s+\(([\d.]+)\s+fps\)"
)

RESOLUTIONS = [(320, 240), (1280, 720), (1920, 1080)]
THREAD_COUNTS = [1, 2, 4, 8, "all"]


def parse_fps(text):
    m = STATS_RE.search(text)
    return float(m.group(3)) if m else 0.0


def run_encode(cli_bin, yuv_file, width, height, frames, preset, threads=None):
    cmd = [
        cli_bin,
        "--input-res", f"{width}x{height}",
        "--fps", "25",
        "--frames", str(frames),
        "--preset", preset,
        "-o", os.devnull,
    ]
    if threads is not None:
        cmd.extend(["--pools", str(threads)])
    cmd.append(yuv_file)
    result = subprocess.run(cmd, capture_output=True, text=True)
    text = result.stderr + "\n" + result.stdout
    fps = parse_fps(text)
    if fps == 0.0:
        print(f"[BENCHMARK_MICRO][DEBUG] threads={threads} returncode={result.returncode}")
        print(f"[BENCHMARK_MICRO][DEBUG] cmd: {' '.join(cmd)}")
        print(f"[BENCHMARK_MICRO][DEBUG] raw output (last 2500 chars):")
        print(text[-2500:])
    return fps


def main():
    if len(sys.argv) < 4:
        print("Usage: micro_benchmark.py <cli_bin> <output_json> [iterations]")
        sys.exit(1)
    cli_bin, output_file = sys.argv[1], sys.argv[2]
    iterations = int(sys.argv[3]) if len(sys.argv) >= 4 else 1

    if not os.path.exists(cli_bin):
        print(f"[BENCHMARK_MICRO] x265 CLI not found: {cli_bin}")
        sys.exit(1)

    tmpdir = tempfile.mkdtemp(prefix="x265_micro_")
    try:
        resolution_results = {}
        for (w, h) in RESOLUTIONS:
            yuv = os.path.join(tmpdir, f"{w}x{h}.yuv")
            generate_yuv(w, h, 10, yuv)
            fps_vals = []
            for _ in range(iterations):
                fps = run_encode(cli_bin, yuv, w, h, 10, "medium")
                if fps > 0:
                    fps_vals.append(fps)
            avg_fps = round(sum(fps_vals) / len(fps_vals), 2) if fps_vals else 0.0
            enc_time = round(10 / avg_fps, 4) if avg_fps > 0 else 0.0
            resolution_results[f"{w}x{h}"] = {"fps": avg_fps, "encode_time_s": enc_time}
            print(f"[BENCHMARK_MICRO] {w}x{h}: {avg_fps} fps")

        thread_results = {}
        ref_w, ref_h = 1280, 720
        ref_yuv = os.path.join(tmpdir, f"{ref_w}x{ref_h}.yuv")
        generate_yuv(ref_w, ref_h, 30, ref_yuv)
        for tc in THREAD_COUNTS:
            fps_vals = []
            for _ in range(iterations):
                fps = run_encode(cli_bin, ref_yuv, ref_w, ref_h, 30, "medium", threads=tc)
                if fps > 0:
                    fps_vals.append(fps)
            avg_fps = round(sum(fps_vals) / len(fps_vals), 2) if fps_vals else 0.0
            thread_results[f"threads_{tc}"] = {"fps": avg_fps}
            print(f"[BENCHMARK_MICRO] threads {tc}: {avg_fps} fps")
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

    version_str = os.environ.get("SOFTWARE_VERSION", "4.2")
    out = {
        "benchmark": "micro_operations",
        "description": "x265 micro: resolution scaling + thread scaling on ARM64",
        "reference": "https://bitbucket.org/multicoreware/x265_git",
        "software": "x265",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "fps": {"unit": "fps", "description": "Encoding frames per second"},
        },
        "parameters": {
            "resolutions": [f"{w}x{h}" for w, h in RESOLUTIONS],
            "thread_counts": [str(t) for t in THREAD_COUNTS],
            "iterations": iterations,
        },
        "results": {
            "resolution_scaling": resolution_results,
            "thread_scaling": thread_results,
        },
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_MICRO] Output written to {output_file}")


if __name__ == "__main__":
    main()
