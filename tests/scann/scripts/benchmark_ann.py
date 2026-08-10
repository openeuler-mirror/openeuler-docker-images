#!/usr/bin/env python3
import json
import time
import argparse
import datetime
import os
import math
import numpy as np
import scann

INDEX_CONFIGS = {
    "ScaNN_L2_AH": {
        "distance": "squared_l2",
        "description": "ScaNN asymmetric hashing (AH) tree, squared L2 distance",
    },
    "ScaNN_IP_AH": {
        "distance": "dot_product",
        "description": "ScaNN asymmetric hashing (AH) tree, inner product (dot) distance",
    },
}

LEAVES_TO_SEARCH_VALUES = [10, 50, 100, 200, 500]

SCALE_MAP = {
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
    "100M": 100000000,
}


def generate_data(n, d, distance, seed=42):
    np.random.seed(seed)
    xb = np.float32(np.random.random((n, d)))
    nq = min(10000, n // 10)
    xq = np.float32(np.random.random((nq, d)))
    return xb, xq


def compute_ground_truth_l2(xb, xq, k):
    nq = xq.shape[0]
    gt_I = np.zeros((nq, k), dtype=np.int64)
    xb_sq = np.einsum('ij,ij->i', xb, xb)
    chunk = min(1000, nq)
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        dots = np.dot(xq[i:end], xb.T)
        dists = xb_sq[None, :] + np.einsum('ij,ij->i', xq[i:end], xq[i:end])[:, None] - 2.0 * dots
        np.maximum(dists, 0, out=dists)
        part = np.argpartition(dists, k, axis=1)[:, :k]
        gt_I[i:end] = part
    return gt_I


def compute_ground_truth_ip(xb, xq, k):
    nq = xq.shape[0]
    gt_I = np.zeros((nq, k), dtype=np.int64)
    chunk = 1000
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        sims = np.dot(xq[i:end], xb.T)
        part = np.argpartition(-sims, k, axis=1)[:, :k]
        gt_I[i:end] = part
    return gt_I


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
    distance = config["distance"]
    num_leaves = max(100, n // 100)

    for iteration in range(iterations):
        print(f'[ANN] {config_name} iteration {iteration+1}/{iterations}')

        builder = scann.scann_ops_pybind.builder(xb, num_neighbors=k, distance_measure=distance)
        build_start = time.time()
        searcher = (
            builder
            .tree(num_leaves=num_leaves, num_leaves_to_search=num_leaves)
            .score_ah(2, anisotropic_quantization_threshold=0.2)
            .reorder(max(k, 100))
            .build()
        )
        build_time = time.time() - build_start

        leaves_results = {}
        for leaves in LEAVES_TO_SEARCH_VALUES:
            actual_leaves = min(leaves, num_leaves)
            search_start = time.time()
            neighbors, distances = searcher.search_batched(
                xq, final_num_neighbors=k, leaves_to_search=actual_leaves
            )
            search_time = time.time() - search_start

            qps = nq / search_time if search_time > 0 else 0
            latency_per_query_us = (search_time / nq) * 1e6 if nq > 0 else 0
            recall = compute_recall(neighbors, gt_I, k)

            leaves_results[leaves] = {
                "search_time_s": round(search_time, 6),
                "qps": round(qps, 2),
                "latency_per_query_us": round(latency_per_query_us, 2),
                f"recall_at_{k}": round(recall, 4),
                "leaves_to_search": actual_leaves,
            }

        result = {
            "iteration": iteration + 1,
            "build_time_s": round(build_time, 4),
            "num_leaves": num_leaves,
            "leaves_sweep": leaves_results,
            "num_vectors": n,
            "num_queries": nq,
        }
        results.append(result)

    avg_build = round(sum(r["build_time_s"] for r in results) / len(results), 4)
    avg_leaves_sweep = {}
    for leaves in LEAVES_TO_SEARCH_VALUES:
        avg_leaves_sweep[leaves] = {}
        for key in results[0]["leaves_sweep"][leaves]:
            vals = [r["leaves_sweep"][leaves][key] for r in results]
            avg_leaves_sweep[leaves][key] = round(sum(vals) / len(vals), 4)

    avg_results = {
        "avg_build_time_s": avg_build,
        "avg_leaves_sweep": avg_leaves_sweep,
    }
    return avg_results, results


def main():
    parser = argparse.ArgumentParser(description='ScaNN ANN Benchmark (ann-benchmarks methodology)')
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
        print(f'[ANN] Preparing data for {config_name} (distance={config["distance"]})...')
        xb, xq = generate_data(n, d, config["distance"])
        nq = xq.shape[0]

        print(f'[ANN] Computing ground truth for distance={config["distance"]}...')
        if config["distance"] == "squared_l2":
            gt_I = compute_ground_truth_l2(xb, xq, k)
        elif config["distance"] == "dot_product":
            gt_I = compute_ground_truth_ip(xb, xq, k)

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
        "description": "Approximate Nearest Neighbor search benchmark following ann-benchmarks methodology for ScaNN",
        "reference": "https://github.com/google-research/google-research/tree/master/scann",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "qps": {
                "unit": "queries/sec",
                "description": "Queries per second throughput at different leaves_to_search values"
            },
            "recall_at_k": {
                "unit": "ratio (0-1)",
                "description": f"Recall@{k} - fraction of true nearest neighbors found"
            },
            "build_time": {
                "unit": "seconds",
                "description": "Time to train ScaNN AH index and create searcher"
            },
            "latency_per_query": {
                "unit": "microseconds",
                "description": "Average latency per single query"
            },
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
            "leaves_to_search_values": LEAVES_TO_SEARCH_VALUES,
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
            print(f'[ANN] {name}: Build={res["avg_build_time_s"]}s')
            for leaves, l_res in res["avg_leaves_sweep"].items():
                print(f'[ANN]   leaves={leaves}: QPS={l_res["qps"]}, Recall@{k}={l_res[f"recall_at_{k}"]}')
    print('[ANN] Benchmark complete')


if __name__ == '__main__':
    main()
