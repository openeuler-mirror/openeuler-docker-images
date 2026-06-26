#!/usr/bin/env python3
import json
import os
import sys
from datetime import datetime, timezone


def aggregate_results(results_dir, output_file):
    merged = {
        "software_name": "openviking",
        "primary_benchmark": {},
        "micro_benchmark": {},
        "environment": {},
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    }

    benchmarks = {
        "benchmark_context.json": "primary_benchmark",
        "micro_benchmark.json": "micro_benchmark"
    }

    for filename, key in benchmarks.items():
        filepath = os.path.join(results_dir, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath) as f:
                    data = json.load(f)
                merged[key] = data
                print(f"[AGGREGATE] Loaded {key} from {filepath}")
            except Exception as e:
                print(f"[AGGREGATE] Failed to load {filepath}: {e}")

    env_file = os.path.join(results_dir, "version_info.json")
    if os.path.exists(env_file):
        try:
            with open(env_file) as f:
                merged["environment"] = json.load(f)
            print(f"[AGGREGATE] Loaded environment from {env_file}")
        except Exception as e:
            print(f"[AGGREGATE] Failed to load {env_file}: {e}")

    test_time = merged.get("environment", {}).get("test_time", "")
    if test_time:
        merged["test_time"] = test_time
    else:
        merged["test_time"] = merged["timestamp"]

    with open(output_file, "w") as f:
        json.dump(merged, f, indent=2)
    print(f"[AGGREGATE] Aggregated results saved to {output_file}")

    return merged


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: aggregate_results.py <results_dir> <output_file>")
        sys.exit(1)

    results_dir = sys.argv[1]
    output_file = sys.argv[2]
    aggregate_results(results_dir, output_file)
