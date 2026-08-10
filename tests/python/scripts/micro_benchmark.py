#!/usr/bin/env python3
import subprocess
import sys
import os
import json
from datetime import datetime, timezone

MICRO_OPS = [
    ("list_comprehension", "[i*2 for i in range({n})]", [1000, 10000, 100000]),
    ("dict_get", "d.get(0)", [1000, 10000, 100000]),
    ("string_concat", "s + 'x'", [100, 1000, 10000]),
    ("json_parse", "json.loads(j)", [1000, 10000]),
]

THREAD_COUNTS = [1, 2, 4, 8, "all"]


def get_max_threads():
    try:
        return int(os.cpu_count() or 4)
    except Exception:
        return 4


def run_timeit(python_bin, stmt, setup, number, repeat=5):
    cmd = [
        python_bin, "-c",
        f"import timeit; t = timeit.repeat('{stmt}', '{setup}', number={number}, repeat={repeat}); "
        f"print(min(t) / {number})",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    if result.returncode != 0:
        print(f"[MICRO][DEBUG] timeit failed: {result.stderr[:200]}")
        return 0.0
    try:
        return float(result.stdout.strip())
    except ValueError:
        return 0.0


def bench_micro_ops(python_bin):
    results = {}
    for name, stmt_tmpl, sizes in MICRO_OPS:
        size_results = {}
        for n in sizes:
            stmt = stmt_tmpl.format(n=n)
            setup = ""
            if "dict_get" in name:
                setup = f"d = {{i: i for i in range({n})}}"
            elif "string_concat" in name:
                setup = f"s = 'x' * {n}"
            elif "json_parse" in name:
                setup = "import json; import json as j_module; j = json.dumps({{str(i): i for i in range(100)}}) * {n}".replace("{n}", str(min(n, 100)))
                stmt = "json.loads(j)"
            seconds_per_op = run_timeit(python_bin, stmt, setup, number=1000)
            ops_per_sec = round(1.0 / seconds_per_op, 2) if seconds_per_op > 0 else 0
            size_results[f"size_{n}"] = {
                "seconds_per_op": round(seconds_per_op, 8),
                "ops_per_sec": ops_per_sec,
            }
            print(f"[MICRO] {name} size_{n}: {ops_per_sec} ops/sec")
        results[name] = size_results
    return results


def bench_thread_scaling(python_bin):
    max_threads = get_max_threads()
    results = {}
    for tc in THREAD_COUNTS:
        actual = tc if tc != "all" else max_threads
        label = f"threads_{tc}"
        stmt = "[i*2 for i in range(10000)]"
        env = os.environ.copy()
        env["OMP_NUM_THREADS"] = str(actual)
        cmd = [
            python_bin, "-c",
            f"import timeit; t = timeit.repeat('{stmt}', number=1000, repeat=3); "
            f"print(min(t) / 1000)",
        ]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60, env=env)
        try:
            sec = float(result.stdout.strip())
            ops = round(1.0 / sec, 2) if sec > 0 else 0
        except ValueError:
            sec, ops = 0, 0
        results[label] = {"seconds_per_op": round(sec, 8), "ops_per_sec": ops}
        print(f"[MICRO] {label}: {ops} ops/sec")
    return results


def main():
    if len(sys.argv) < 4:
        print("Usage: micro_benchmark.py <python_bin> <output_file> [iterations]")
        sys.exit(1)
    python_bin = sys.argv[1]
    output_file = sys.argv[2]
    iterations = int(sys.argv[3]) if len(sys.argv) >= 4 else 1

    if not os.path.exists(python_bin):
        print(f"[MICRO] Python binary not found: {python_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "3.14.7")
    max_threads = get_max_threads()

    print("[MICRO] Running micro_ops...")
    ops_results = bench_micro_ops(python_bin)

    print("[MICRO] Running thread_scaling...")
    ts_results = bench_thread_scaling(python_bin)

    out = {
        "benchmark": "micro_operations",
        "description": f"CPython micro: timeit operations + GIL thread scaling on ARM64",
        "reference": "https://github.com/python/cpython",
        "software": "python",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "ops_per_sec": {"unit": "ops/sec", "description": "Operations per second"},
            "seconds_per_op": {"unit": "s", "description": "Seconds per operation"},
        },
        "parameters": {
            "micro_ops": [name for name, _, _ in MICRO_OPS],
            "thread_counts": [str(t) for t in THREAD_COUNTS],
            "max_threads": max_threads,
            "iterations": iterations,
        },
        "results": {
            "micro_ops": ops_results,
            "thread_scaling": ts_results,
        },
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[MICRO] Output written to {output_file}")


if __name__ == "__main__":
    main()
