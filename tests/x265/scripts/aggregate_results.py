#!/usr/bin/env python3
import json
import os
import sys
from datetime import datetime, timezone


def safe_float(val, default=0.0):
    try:
        return float(val)
    except (ValueError, TypeError):
        return default


def compute_summary(primary, micro):
    summary = {}
    rs = primary.get("results_summary", {})

    fps_vals = []
    psnr_vals = []
    bitrate_vals = []
    per_preset_fps = {}
    for key, res in rs.items():
        if not isinstance(res, dict):
            continue
        preset = res.get("preset", key)
        fps = safe_float(res.get("fps", 0)) if res.get("fps") else None
        psnr = safe_float(res.get("psnr_db", 0)) if res.get("psnr_db") else None
        br = safe_float(res.get("bitrate_kbps", 0)) if res.get("bitrate_kbps") else None
        if fps is not None and fps > 0:
            fps_vals.append(fps)
            per_preset_fps[preset] = fps
        if psnr is not None and psnr > 0:
            psnr_vals.append(psnr)
        if br is not None and br > 0:
            bitrate_vals.append(br)

    if fps_vals:
        summary["avg_fps"] = round(sum(fps_vals) / len(fps_vals), 2)
        summary["max_fps"] = round(max(fps_vals), 2)
        summary["min_fps"] = round(min(fps_vals), 2)
    if psnr_vals:
        summary["avg_psnr_db"] = round(sum(psnr_vals) / len(psnr_vals), 2)
        summary["max_psnr_db"] = round(max(psnr_vals), 2)
    if bitrate_vals:
        summary["avg_bitrate_kbps"] = round(sum(bitrate_vals) / len(bitrate_vals), 2)

    for preset in ["ultrafast", "fast", "medium", "slow", "veryslow"]:
        if preset in per_preset_fps:
            summary[f"preset_{preset}_fps"] = per_preset_fps[preset]
    for preset in ["ultrafast", "medium", "veryslow"]:
        # best speed = ultrafast, balanced = medium, best quality = veryslow
        pass

    mresults = micro.get("results", {})
    if isinstance(mresults, dict):
        res_scale = mresults.get("resolution_scaling", {})
        if isinstance(res_scale, dict):
            for res, e in res_scale.items():
                if isinstance(e, dict) and e.get("fps"):
                    summary[f"res_{res}_fps"] = safe_float(e["fps"])
        ts = mresults.get("thread_scaling", {})
        if isinstance(ts, dict):
            one = safe_float(ts.get("threads_1", {}).get("fps", 0)) if isinstance(ts.get("threads_1"), dict) else 0
            allq = safe_float(ts.get("threads_all", {}).get("fps", 0)) if isinstance(ts.get("threads_all"), dict) else 0
            if one > 0 and allq > 0:
                summary["thread_scaling_ratio"] = round(allq / one, 2)

    return summary


def aggregate_results(results_dir, output_file):
    primary = {}
    micro = {}
    version_info = {}

    for fname, key in [("benchmark_encode.json", "primary"), ("micro_benchmark.json", "micro")]:
        path = os.path.join(results_dir, fname)
        if os.path.exists(path):
            with open(path) as f:
                data = json.load(f)
            if key == "primary":
                primary = data
            else:
                micro = data
            print(f"[AGGREGATE] Loaded {key} from {path}")

    env_path = os.path.join(results_dir, "version_info.json")
    if os.path.exists(env_path):
        with open(env_path) as f:
            version_info = json.load(f)
        print(f"[AGGREGATE] Loaded environment from {env_path}")

    summary = compute_summary(primary, micro)

    result = {
        "test_time": version_info.get("test_time", version_info.get("timestamp",
                       datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"))),
        "environment": version_info,
        "benchmarks": {
            "primary": primary,
            "micro": micro,
        },
        "summary": summary,
        "software": "x265",
        "version": version_info.get("software_version", "rolling"),
    }

    os.makedirs(os.path.dirname(os.path.abspath(output_file)) or ".", exist_ok=True)
    with open(output_file, "w") as f:
        json.dump(result, f, indent=2)
    print(f"[AGGREGATE] Aggregated results saved to {output_file}")
    return result


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: aggregate_results.py <results_dir> <output_file>")
        sys.exit(1)
    aggregate_results(sys.argv[1], sys.argv[2])
