#!/usr/bin/env python3
import argparse
import json
import time
import sys
import subprocess
import os

SOFTWARE_NAME = "rust"

def time_operation(name, func, iterations):
    times = []
    for _ in range(iterations):
        start = time.time()
        try:
            func()
        except Exception:
            pass
        times.append(time.time() - start)
    avg = sum(times) / len(times) if times else 0
    min_t = min(times) if times else 0
    max_t = max(times) if times else 0
    return {
        "avg_time_s": round(avg, 4),
        "min_time_s": round(min_t, 4),
        "max_time_s": round(max_t, 4),
        "iterations": iterations,
    }

def detect_and_benchmark(iterations):
    results = {
        "benchmark": "micro_operations",
        "description": f"{SOFTWARE_NAME} micro benchmark",
        "reference": "SKILL.md",
        "parameters": {
            "iterations": iterations,
        },
        "performance_metrics": {},
        "results": {},
    }

    op_results = {}

    py_modules = {
        "faiss": "faiss", "hnswlib": "hnswlib", "lz4": "lz4",
        "protobuf": "google.protobuf", "pytorch": "torch",
        "scann": "scann", "openviking": "openviking",
        "numpy": "numpy", "pandas": "pandas", "scipy": "scipy",
    }
    for sw_name, module in py_modules.items():
        try:
            mod = __import__(module)
            op_results["import_" + sw_name] = time_operation(
                "import_" + sw_name,
                lambda: __import__(module),
                1,
            )
            ver = getattr(mod, "__version__", "unknown")
            op_results["import_" + sw_name]["version"] = ver
        except ImportError:
            pass

    binaries = ["redis-cli", "mysql", "nginx", "go", "java", "python3", "docker", "kubectl", "etcd"]
    for b in binaries:
        try:
            r = subprocess.run(["which", b], capture_output=True, text=True, timeout=5)
            if r.returncode == 0:
                op_results["which_" + b] = time_operation(
                    "which_" + b,
                    lambda: subprocess.run(["which", b], capture_output=True, timeout=5),
                    iterations,
                )
        except Exception:
            pass

    cpu_count = os.cpu_count() or 1
    op_results["system_info"] = {
        "cpu_cores": cpu_count,
        "platform": sys.platform,
        "python_version": sys.version.split()[0],
    }

    results["results"] = op_results
    results["performance_metrics"]["operation_count"] = len(op_results)
    return results

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True)
    parser.add_argument("--version", default="unknown")
    parser.add_argument("--iterations", type=int, default=1)
    args = parser.parse_args()
    data = detect_and_benchmark(args.iterations)
    data["version"] = args.version
    with open(args.output, "w") as f:
        json.dump(data, f, indent=2)
    print(f"[MICRO] Output written to {args.output}")
