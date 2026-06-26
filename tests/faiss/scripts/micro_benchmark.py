#!/usr/bin/env python3
import json
import time
import os
import numpy as np
import faiss
from datetime import datetime, timezone

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
RESULTS_DIR = os.environ.get(
    "RESULTS_DIR",
    os.path.join(os.path.dirname(SCRIPT_DIR), "results")
)
DATA_SCALE = os.environ.get("DATA_SCALE", "100K")
DATA_DIM = int(os.environ.get("DATA_DIM", "128"))
ITERATIONS = int(os.environ.get("ITERATIONS", "1"))

SCALE_MAP = {
    "1K": 1000,
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
}


def bench_kmeans(xb, d, k_centroids=100, iterations=1):
    results = []
    for i in range(iterations):
        start = time.time()
        kmeans = faiss.Kmeans(d, k_centroids, niter=20, verbose=False)
        kmeans.train(xb)
        elapsed = time.time() - start
        results.append({"iteration": i + 1, "elapsed_s": round(elapsed, 4)})
    avg_time = round(sum(r["elapsed_s"] for r in results) / len(results), 4)
    return {
        "test": "kmeans_clustering",
        "description": "K-means clustering on random vectors (100 centroids, 20 iters)",
        "avg_time_s": avg_time,
        "avg_latency_ms": round(avg_time * 1000, 2)
    }


def bench_add_vectors(xb, d, iterations=1):
    results = []
    n = xb.shape[0]
    for i in range(iterations):
        index = faiss.IndexFlatL2(d)
        start = time.time()
        index.add(xb)
        elapsed = time.time() - start
        add_rate = n / elapsed if elapsed > 0 else 0
        results.append({"iteration": i + 1, "elapsed_s": round(elapsed, 4), "add_rate": round(add_rate, 2)})
    avg_time = round(sum(r["elapsed_s"] for r in results) / len(results), 4)
    avg_rate = round(sum(r["add_rate"] for r in results) / len(results), 2)
    return {
        "test": "add_vectors_flat",
        "description": "Add vectors to IndexFlatL2 (bulk insertion throughput)",
        "avg_time_s": avg_time,
        "add_rate_per_sec": avg_rate,
        "avg_latency_ms": round(avg_time * 1000, 2)
    }


def bench_search_single(xb, d, iterations=1):
    results = []
    index = faiss.IndexFlatL2(d)
    index.add(xb)
    xq_single = xb[:1]
    for i in range(iterations):
        start = time.time()
        for _ in range(1000):
            D, I = index.search(xq_single, 10)
        elapsed = time.time() - start
        latency_us = (elapsed / 1000) * 1e6
        results.append({"iteration": i + 1, "total_time_s": round(elapsed, 4), "latency_us": round(latency_us, 2)})
    avg_latency = round(sum(r["latency_us"] for r in results) / len(results), 2)
    return {
        "test": "search_single_flat",
        "description": "Single query search on IndexFlatL2 (per-query latency)",
        "avg_latency_us": avg_latency,
        "avg_latency_ms": round(avg_latency / 1000, 4)
    }


def bench_search_batch(xb, d, nq=1000, k=10, iterations=1):
    results = []
    index = faiss.IndexFlatL2(d)
    index.add(xb)
    xq = np.random.random((nq, d)).astype('float32')
    for i in range(iterations):
        start = time.time()
        D, I = index.search(xq, k)
        elapsed = time.time() - start
        qps = nq / elapsed if elapsed > 0 else 0
        results.append({"iteration": i + 1, "time_s": round(elapsed, 4), "qps": round(qps, 2)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_qps = round(sum(r["qps"] for r in results) / len(results), 2)
    return {
        "test": "search_batch_flat",
        "description": "Batch query search on IndexFlatL2 (batch throughput)",
        "avg_time_s": avg_time,
        "avg_qps": avg_qps,
        "avg_latency_ms": round(avg_time * 1000, 2)
    }


def bench_range_search(xb, d, iterations=1):
    results = []
    index = faiss.IndexFlatL2(d)
    index.add(xb)
    xq = xb[:100]
    radius = 5.0
    for i in range(iterations):
        start = time.time()
        lims, D, I = index.range_search(xq, radius)
        elapsed = time.time() - start
        nq = xq.shape[0]
        qps = nq / elapsed if elapsed > 0 else 0
        avg_results_per_query = (lims[-1] - lims[0]) / nq if nq > 0 else 0
        results.append({"iteration": i + 1, "time_s": round(elapsed, 4), "qps": round(qps, 2), "avg_results_per_query": round(avg_results_per_query, 2)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_qps = round(sum(r["qps"] for r in results) / len(results), 2)
    return {
        "test": "range_search_flat",
        "description": "Range search on IndexFlatL2 (radius-based search)",
        "avg_time_s": avg_time,
        "avg_qps": avg_qps,
        "avg_latency_ms": round(avg_time * 1000, 2)
    }


def bench_pq_encoding(xb, d, iterations=1):
    results = []
    n = xb.shape[0]
    pq = faiss.IndexPQ(d, 8, 8)
    train_data = xb[:min(n, 50000)]
    pq.train(train_data)
    for i in range(iterations):
        start = time.time()
        pq.add(xb)
        elapsed = time.time() - start
        encode_rate = n / elapsed if elapsed > 0 else 0
        results.append({"iteration": i + 1, "time_s": round(elapsed, 4), "encode_rate": round(encode_rate, 2)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_rate = round(sum(r["encode_rate"] for r in results) / len(results), 2)
    return {
        "test": "pq_encoding",
        "description": "Product Quantization encoding throughput",
        "avg_time_s": avg_time,
        "encode_rate_per_sec": avg_rate,
        "avg_latency_ms": round(avg_time * 1000, 2)
    }


def main():
    data_scale = DATA_SCALE
    d = DATA_DIM
    iterations = ITERATIONS

    os.makedirs(RESULTS_DIR, exist_ok=True)

    n = SCALE_MAP.get(data_scale, 100000)

    print(f'[MICRO] Generating {n} vectors of dimension {d}...')
    np.random.seed(42)
    xb = np.random.random((n, d)).astype('float32')

    all_results = []

    print('[MICRO] Running kmeans_clustering...')
    all_results.append(bench_kmeans(xb, d, iterations=iterations))

    print('[MICRO] Running add_vectors_flat...')
    all_results.append(bench_add_vectors(xb, d, iterations=iterations))

    print('[MICRO] Running search_single_flat...')
    all_results.append(bench_search_single(xb, d, iterations=iterations))

    print('[MICRO] Running search_batch_flat...')
    all_results.append(bench_search_batch(xb, d, iterations=iterations))

    print('[MICRO] Running range_search_flat...')
    all_results.append(bench_range_search(xb, d, iterations=iterations))

    print('[MICRO] Running pq_encoding...')
    all_results.append(bench_pq_encoding(xb, d, iterations=iterations))

    avg_latency_ms = sum(r["avg_latency_ms"] for r in all_results) / len(all_results)

    output = {
        "benchmark": "micro_operations",
        "description": "Micro-level benchmarks for core Faiss operations on ARM64",
        "reference": "Faiss library built-in operations (https://github.com/facebookresearch/faiss)",
        "software": "faiss",
        "version": getattr(faiss, '__version__', 'unknown'),
        "architecture": os.environ.get("ARCH", "aarch64"),
        "build_method": "source_build",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "avg_latency_ms": {
                "unit": "ms",
                "description": "Average latency per micro operation"
            },
            "search_latency_us": {
                "unit": "microseconds",
                "description": "Per-query latency for single vector search"
            },
            "add_rate": {
                "unit": "vectors/sec",
                "description": "Vector addition rate to IndexFlatL2"
            }
        },
        "dataset_info": {
            "name": "synthetic_random_float32",
            "size": f"{data_scale} vectors x {d} dimensions",
            "source": "numpy random uniform distribution"
        },
        "parameters": {
            "num_vectors": n,
            "dimension": d,
            "iterations": iterations
        },
        "avg_latency_ms": round(avg_latency_ms, 2),
        "results": all_results
    }

    output_path = os.path.join(RESULTS_DIR, 'micro_benchmark.json')
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)

    print(f'[MICRO] Results saved to: {output_path}')
    print('[MICRO] Benchmark complete')


if __name__ == '__main__':
    main()
