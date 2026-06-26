#!/usr/bin/env python3
import json
import time
import argparse
import datetime
import os
import numpy as np
import hnswlib

INDEX_CONFIGS = {
    "HNSW_L2_M16_ef200": {
        "space": "l2",
        "M": 16,
        "ef_construction": 200,
        "description": "HNSW L2 index, M=16 (default), ef_construction=200",
    },
    "HNSW_L2_M32_ef200": {
        "space": "l2",
        "M": 32,
        "ef_construction": 200,
        "description": "HNSW L2 index, M=32 (higher connectivity), ef_construction=200",
    },
    "HNSW_L2_M64_ef200": {
        "space": "l2",
        "M": 64,
        "ef_construction": 200,
        "description": "HNSW L2 index, M=64 (max connectivity), ef_construction=200",
    },
    "HNSW_Cosine_M16_ef200": {
        "space": "cosine",
        "M": 16,
        "ef_construction": 200,
        "description": "HNSW Cosine index, M=16, ef_construction=200",
    },
    "HNSW_IP_M16_ef200": {
        "space": "ip",
        "M": 16,
        "ef_construction": 200,
        "description": "HNSW Inner Product index, M=16, ef_construction=200",
    },
}

EF_SEARCH_VALUES = [10, 50, 100, 200, 500]

SCALE_MAP = {
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
    "100M": 100000000,
}

def generate_data(n, d, space, seed=42):
    np.random.seed(seed)
    xb = np.float32(np.random.random((n, d)))
    if space == "cosine":
        norms = np.linalg.norm(xb, axis=1, keepdims=True)
        xb = xb / norms
    nq = min(10000, n // 10)
    xq = np.float32(np.random.random((nq, d)))
    if space == "cosine":
        norms = np.linalg.norm(xq, axis=1, keepdims=True)
        xq = xq / norms
    return xb, xq

def compute_ground_truth_l2(xb, xq, k):
    from numpy.linalg import norm
    nq = xq.shape[0]
    nb = xb.shape[0]
    gt_I = np.zeros((nq, k), dtype=np.int64)
    chunk = min(100, nq)
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        dists = np.sum((xq[i:end].reshape(end - i, 1, -1) - xb.reshape(1, nb, -1)) ** 2, axis=2)
        gt_I[i:end] = np.argsort(dists, axis=1)[:, :k]
    return gt_I

def compute_ground_truth_ip(xb, xq, k):
    nq = xq.shape[0]
    nb = xb.shape[0]
    gt_I = np.zeros((nq, k), dtype=np.int64)
    chunk = 1000
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        sims = np.dot(xq[i:end], xb.T)
        gt_I[i:end] = np.argsort(-sims, axis=1)[:, :k]
    return gt_I

def compute_ground_truth_cosine(xb, xq, k):
    xb_norm = xb / np.linalg.norm(xb, axis=1, keepdims=True)
    xq_norm = xq / np.linalg.norm(xq, axis=1, keepdims=True)
    return compute_ground_truth_ip(xb_norm, xq_norm, k)

def compute_recall(labels, gt_I, k):
    nq = labels.shape[0]
    recall = 0.0
    for i in range(nq):
        recall += len(set(labels[i].tolist()) & set(gt_I[i].tolist())) / k
    return recall / nq

def benchmark_index(config_name, config, xb, xq, d, k, iterations, gt_I):
    results = []
    n = xb.shape[0]
    nq = xq.shape[0]
    space = config["space"]
    M = config["M"]
    ef_construction = config["ef_construction"]

    for iteration in range(iterations):
        print(f'[ANN] {config_name} iteration {iteration+1}/{iterations}')

        index = hnswlib.Index(space=space, dim=d)
        index.init_index(max_elements=n, ef_construction=ef_construction, M=M)

        build_start = time.time()
        index.add_items(xb, np.arange(n), num_threads=-1)
        build_time = time.time() - build_start

        ef_results = {}
        for ef in EF_SEARCH_VALUES:
            index.set_ef(ef)
            search_start = time.time()
            labels, distances = index.knn_query(xq, k=k, num_threads=-1)
            search_time = time.time() - search_start

            qps = nq / search_time if search_time > 0 else 0
            latency_per_query_us = (search_time / nq) * 1e6 if nq > 0 else 0
            recall = compute_recall(labels, gt_I, k)

            ef_results[ef] = {
                "search_time_s": round(search_time, 6),
                "qps": round(qps, 2),
                "latency_per_query_us": round(latency_per_query_us, 2),
                f"recall_at_{k}": round(recall, 4),
            }

        index_path = os.path.join('/tmp', f'hnsw_bench_{config_name}_{iteration}.bin')
        index.save_index(index_path)
        index_size = os.path.getsize(index_path)
        os.remove(index_path)

        result = {
            "iteration": iteration + 1,
            "build_time_s": round(build_time, 4),
            "index_size_bytes": index_size,
            "ef_sweep": ef_results,
            "num_vectors": n,
            "num_queries": nq,
        }
        results.append(result)

    avg_build = round(sum(r["build_time_s"] for r in results) / len(results), 4)
    avg_index_size = round(sum(r["index_size_bytes"] for r in results) / len(results))
    avg_ef_sweep = {}
    for ef in EF_SEARCH_VALUES:
        avg_ef_sweep[ef] = {}
        for key in results[0]["ef_sweep"][ef]:
            vals = [r["ef_sweep"][ef][key] for r in results]
            avg_ef_sweep[ef][key] = round(sum(vals) / len(vals), 4)

    avg_results = {
        "avg_build_time_s": avg_build,
        "avg_index_size_bytes": avg_index_size,
        "avg_ef_sweep": avg_ef_sweep,
    }

    return avg_results, results

def main():
    parser = argparse.ArgumentParser(description='hnswlib ANN Benchmark (ann-benchmarks methodology)')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--data-scale', default='1M', choices=list(SCALE_MAP.keys()))
    parser.add_argument('--data-dim', type=int, default=128)
    parser.add_argument('--iterations', type=int, default=3)
    parser.add_argument('--k', type=int, default=10)
    args = parser.parse_args()

    n = SCALE_MAP[args.data_scale]
    d = args.data_dim
    k = args.k

    all_results = {}
    detailed_results = {}

    for config_name, config in INDEX_CONFIGS.items():
        print(f'[ANN] Preparing data for {config_name} (space={config["space"]})...')
        xb, xq = generate_data(n, d, config["space"])
        nq = xq.shape[0]

        print(f'[ANN] Computing ground truth for space={config["space"]}...')
        if config["space"] == "l2":
            gt_I = compute_ground_truth_l2(xb, xq, k)
        elif config["space"] == "ip":
            gt_I = compute_ground_truth_ip(xb, xq, k)
        elif config["space"] == "cosine":
            gt_I = compute_ground_truth_cosine(xb, xq, k)

        print(f'[ANN] Benchmarking {config_name}: {config["description"]}')
        try:
            avg, detailed = benchmark_index(
                config_name, config, xb, xq, d, k, args.iterations, gt_I
            )
            all_results[config_name] = avg
            detailed_results[config_name] = detailed
        except Exception as e:
            print(f'[ANN] ERROR benchmarking {config_name}: {e}')
            all_results[config_name] = {"error": str(e)}

    output = {
        "benchmark": "ann_search",
        "description": "Approximate Nearest Neighbor search benchmark following ann-benchmarks methodology for hnswlib",
        "reference": "https://github.com/erikbern/ann-benchmarks",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "qps": {
                "unit": "queries/sec",
                "description": "Queries per second throughput at different ef_search values"
            },
            "recall_at_k": {
                "unit": "ratio (0-1)",
                "description": f"Recall@{k} - fraction of true nearest neighbors found"
            },
            "build_time": {
                "unit": "seconds",
                "description": "Time to add all vectors to the HNSW index"
            },
            "latency_per_query": {
                "unit": "microseconds",
                "description": "Average latency per single query"
            },
            "index_size": {
                "unit": "bytes",
                "description": "Serialized index file size"
            }
        },
        "dataset_info": {
            "name": "synthetic_random_float32",
            "size": f"{args.data_scale} vectors x {d} dimensions",
            "source": "numpy random uniform distribution"
        },
        "parameters": {
            "num_vectors": n,
            "dimension": d,
            "num_queries": min(10000, n // 10),
            "k": k,
            "iterations": args.iterations,
            "ef_search_values": EF_SEARCH_VALUES,
            "index_configs": {name: cfg for name, cfg in INDEX_CONFIGS.items()}
        },
        "results_summary": all_results,
        "results_detailed": detailed_results
    }

    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(output, f, indent=2)

    print(f'[ANN] Results saved to: {args.output}')
    for name, res in all_results.items():
        if "error" not in res:
            print(f'[ANN] {name}: Build={res["avg_build_time_s"]}s, Size={res["avg_index_size_bytes"]}B')
            for ef, ef_res in res["avg_ef_sweep"].items():
                print(f'[ANN]   ef={ef}: QPS={ef_res["qps"]}, Recall@{k}={ef_res[f"recall_at_{k}"]}')
    print('[ANN] Benchmark complete')

if __name__ == '__main__':
    main()