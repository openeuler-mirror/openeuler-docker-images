#!/usr/bin/env python3
import subprocess
import re
import sys
import os
import json
import tempfile
import time
import signal
from datetime import datetime, timezone

REDIS_CLI = os.environ.get("REDIS_CLI_BIN", "redis-cli")

COMMANDS = ["SET", "GET", "INCR", "LPUSH", "LRANGE_100", "SADD", "HSET", "ZADD"]
CONCURRENCY_LEVELS = [1, 10, 50, 100, 200]

STATS_RE = re.compile(
    r'"([A-Z_0-9]+)[^"]*","([\d.]+)","([\d.]+)","[\d.]+","[\d.]+","[\d.]+","([\d.]+)","[\d.]+"'
)
SIMPLE_RE = re.compile(
    r'([A-Z_0-9]+):\s*([\d.]+)\s+requests per second'
)


def start_redis_server(redis_server_bin, port, db_path, extra_args=None):
    if not os.path.exists(db_path):
        os.makedirs(db_path, exist_ok=True)
    cmd = [
        redis_server_bin,
        "--port", str(port),
        "--dir", db_path,
        "--save", "",
        "--appendonly", "no",
        "--daemonize", "yes",
        "--loglevel", "warning",
        "--pidfile", os.path.join(db_path, "redis.pid"),
    ]
    if extra_args:
        cmd.extend(extra_args)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
    if result.returncode != 0:
        print(f"[BENCHMARK_REDIS] Failed to start redis-server: {result.stderr}")
        return False
    for _ in range(20):
        r = subprocess.run([REDIS_CLI, "-p", str(port), "PING"],
                           capture_output=True, text=True, timeout=2)
        if r.returncode == 0 and "PONG" in r.stdout:
            return True
        time.sleep(0.5)
    print("[BENCHMARK_REDIS] redis-server didn't respond to PING")
    return False


def stop_redis_server(port):
    subprocess.run([REDIS_CLI, "-p", str(port), "SHUTDOWN", "NOSAVE"],
                   capture_output=True, text=True, timeout=5)
    time.sleep(1)


def run_redis_benchmark(redis_bench_bin, port, command, concurrency, data_size=None, iterations=1):
    results = []
    for _ in range(iterations):
        cmd = [
            redis_bench_bin,
            "-h", "127.0.0.1",
            "-p", str(port),
            "-t", command,
            "-c", str(concurrency),
            "-n", "100000",
            "--csv",
        ]
        if data_size is not None:
            cmd.extend(["-d", str(data_size)])
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
        text = result.stdout + "\n" + result.stderr
        parsed = parse_bench_output(text, command)
        if parsed:
            results.append(parsed)
    if not results:
        return {"qps": 0, "avg_latency_ms": 0, "p99_latency_ms": 0}
    avg_qps = round(sum(r["qps"] for r in results) / len(results), 2)
    avg_lat = round(sum(r["avg_latency_ms"] for r in results) / len(results), 4)
    avg_p99 = round(sum(r["p99_latency_ms"] for r in results) / len(results), 4)
    return {"qps": avg_qps, "avg_latency_ms": avg_lat, "p99_latency_ms": avg_p99}


def parse_bench_output(text, command):
    for m in STATS_RE.finditer(text):
        if m.group(1) == command:
            return {
                "qps": float(m.group(2)),
                "avg_latency_ms": float(m.group(3)),
                "p99_latency_ms": float(m.group(4)),
            }
    m2 = SIMPLE_RE.search(text)
    if m2:
        return {"qps": float(m2.group(2)), "avg_latency_ms": 0, "p99_latency_ms": 0}
    return None


def main():
    if len(sys.argv) < 5:
        print("Usage: benchmark_redis.py <redis_server_bin> <redis_bench_bin> <output_file> [iterations]")
        sys.exit(1)
    redis_server_bin = sys.argv[1]
    redis_bench_bin = sys.argv[2]
    output_file = sys.argv[3]
    iterations = int(sys.argv[4]) if len(sys.argv) >= 5 else 1

    if not os.path.exists(redis_server_bin):
        print(f"[BENCHMARK_REDIS] redis-server not found: {redis_server_bin}")
        sys.exit(1)
    if not os.path.exists(redis_bench_bin):
        print(f"[BENCHMARK_REDIS] redis-benchmark not found: {redis_bench_bin}")
        sys.exit(1)

    version_str = os.environ.get("SOFTWARE_VERSION", "8.0.0")
    port = 6390 + os.getpid() % 1000
    db_path = tempfile.mkdtemp(prefix="redis_bench_")

    print(f"[BENCHMARK_REDIS] Starting redis-server on port {port}...")
    if not start_redis_server(redis_server_bin, port, db_path):
        sys.exit(1)

    results_summary = {}
    try:
        for cmd in COMMANDS:
            cmd_results = {}
            for conc in CONCURRENCY_LEVELS:
                label = f"concurrency_{conc}"
                print(f"[BENCHMARK_REDIS] {cmd} @ c={conc}...")
                r = run_redis_benchmark(redis_bench_bin, port, cmd, conc, iterations=iterations)
                cmd_results[label] = r
                print(f"  QPS={r['qps']}, avg_lat={r['avg_latency_ms']}ms, p99={r['p99_latency_ms']}ms")
            results_summary[cmd] = cmd_results
    finally:
        stop_redis_server(port)
        import shutil
        shutil.rmtree(db_path, ignore_errors=True)

    out = {
        "benchmark": "redis_ops",
        "description": f"Redis in-memory KV operations benchmark (commands × concurrency levels) on ARM64",
        "reference": "https://github.com/redis/redis",
        "software": "redis",
        "version": version_str,
        "architecture": "arm64",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "qps": {"unit": "ops/sec", "description": "Queries per second throughput"},
            "avg_latency_ms": {"unit": "ms", "description": "Average latency per request"},
            "p99_latency_ms": {"unit": "ms", "description": "99th percentile latency"},
        },
        "parameters": {
            "commands": COMMANDS,
            "concurrency_levels": CONCURRENCY_LEVELS,
            "num_requests": 100000,
            "iterations": iterations,
            "persistence": "none (in-memory only)",
        },
        "results_summary": results_summary,
    }
    with open(output_file, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[BENCHMARK_REDIS] Output written to {output_file} ({len(results_summary)} commands)")


if __name__ == "__main__":
    main()
