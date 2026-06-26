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
K = int(os.environ.get("K", "10"))

SCALE_MAP = {
    "1K": 1000,
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
}

INDEX_CONFIGS = {
    "FlatL2": {
        "constructor": lambda d: faiss.IndexFlatL2(d),
        "description": "Exact brute-force L2 search",
        "needs_training": False,
    },
    "IVFFlat": {
        "constructor": lambda d: faiss.IndexIVFFlat(faiss.IndexFlatL2(d), d, 100),
        "description": "Inverted file with flat L2 quantizer, 100 lists",
        "needs_training": True,
        "nlist": 100,
    },
    "HNSWFlat": {
        "constructor": lambda d: faiss.IndexHNSWFlat(d, 32),
        "description": "HNSW graph-based index, M=32",
        "needs_training": False,
    },
}


def generate_data(n, d, seed=42):
    np.random.seed(seed)
    xb = np.random.random((n, d)).astype('float32')
    nq = min(1000, n // 10)
    xq = np.random.random((nq, d)).astype('float32')
    return xb, xq


def compute_recall(I_approx, gt_I, k):
    nq = I_approx.shape[0]
    recall = 0.0
    for i in range(nq):
        recall += len(set(I_approx[i].tolist()) & set(gt_I[i].tolist())) / k
    return recall / nq


def benchmark_index(index_name, config, xb, xq, d, k, iterations, gt_D, gt_I):
    results = []
    n = xb.shape[0]
    nq = xq.shape[0]

    for iteration in range(iterations):
        print(f'[ANN] {index_name} iteration {iteration+1}/{iterations}')

        index = config["constructor"](d)

        build_start = time.time()
        train_time = 0
        if config["needs_training"]:
            nlist = config.get("nlist", 100)
            training_size = min(n, max(nlist * 256, 50000))
            train_data = xb[:training_size]
            index.train(train_data)
            train_time = time.time() - build_start

        add_start = time.time()
        index.add(xb)
        add_time = time.time() - add_start
        build_time = time.time() - build_start

        search_start = time.time()
        D, I = index.search(xq, k)
        search_time = time.time() - search_start

        qps = nq / search_time if search_time > 0 else 0
        latency_per_query_us = (search_time / nq) * 1e6 if nq > 0 else 0

        recall = compute_recall(I, gt_I, k)

        mem_bytes = 0
        if hasattr(index, 'ntotal'):
            try:
                serialized = faiss.serialize_index(index)
                mem_bytes = len(serialized)
            except Exception:
                mem_bytes = 0

        result = {
            "iteration": iteration + 1,
            "build_time_s": round(build_time, 4),
            "train_time_s": round(train_time, 4),
            "add_time_s": round(add_time, 4),
            "search_time_s": round(search_time, 6),
            "qps": round(qps, 2),
            "latency_per_query_us": round(latency_per_query_us, 2),
            f"recall_at_{k}": round(recall, 4),
            "index_size_bytes": mem_bytes,
            "num_vectors": n,
            "num_queries": nq,
            "avg_latency_ms": round(latency_per_query_us / 1000, 4),
            "avg_throughput_ops_per_sec": round(qps, 2),
        }
        results.append(result)

    avg_results = {}
    keys = [kk for kk in results[0].keys() if kk != "iteration"]
    for key in keys:
        vals = [r[key] for r in results]
        avg_results[key] = round(sum(vals) / len(vals), 4)

    return avg_results, results


def main():
    data_scale = DATA_SCALE
    d = DATA_DIM
    k = K
    iterations = ITERATIONS

    os.makedirs(RESULTS_DIR, exist_ok=True)

    n = SCALE_MAP.get(data_scale, 100000)

    print(f'[ANN] Generating {n} vectors of dimension {d}...')
    xb, xq = generate_data(n, d)
    nq = xq.shape[0]

    print(f'[ANN] Computing ground truth with IndexFlatL2...')
    gt_index = faiss.IndexFlatL2(d)
    gt_index.add(xb)
    gt_D, gt_I = gt_index.search(xq, k)

    all_results = {}
    results_list = []

    for index_name, config in INDEX_CONFIGS.items():
        print(f'[ANN] Benchmarking {index_name}: {config["description"]}')
        try:
            avg, detailed = benchmark_index(
                index_name, config, xb, xq, d, k, iterations, gt_D, gt_I
            )
            all_results[index_name] = avg
            for det in detailed:
                det["index_name"] = index_name
                results_list.append(det)
        except Exception as e:
            print(f'[ANN] ERROR benchmarking {index_name}: {e}')
            all_results[index_name] = {"error": str(e)}

    output = {
        "benchmark": "ann_search",
        "description": "Approximate Nearest Neighbor search benchmark following ann-benchmarks methodology",
        "reference": "https://github.com/erikbern/ann-benchmarks",
        "software": "faiss",
        "version": getattr(faiss, '__version__', 'unknown'),
        "architecture": os.environ.get("ARCH", "aarch64"),
        "build_method": "source_build",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "performance_metrics": {
            "qps": {
                "unit": "queries/sec",
                "description": "Queries per second throughput"
            },
            "recall_at_k": {
                "unit": "ratio (0-1)",
                "description": f"Recall@{k} - fraction of true nearest neighbors found"
            },
            "build_time": {
                "unit": "seconds",
                "description": "Total time to train and add vectors to index"
            },
            "latency_per_query": {
                "unit": "microseconds",
                "description": "Average latency per single query"
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
            "num_queries": nq,
            "k": k,
            "iterations": iterations
        },
        "results_summary": all_results,
        "results": results_list
    }

    output_path = os.path.join(RESULTS_DIR, 'benchmark_primary.json')
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)

    print(f'[ANN] Results saved to: {output_path}')
    print('[ANN] Benchmark complete')


if __name__ == '__main__':
    main()
