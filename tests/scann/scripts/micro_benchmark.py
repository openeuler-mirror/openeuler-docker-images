#!/usr/bin/env python3
import json
import time
import argparse
import datetime
import os
import numpy as np
import scann

SCALE_MAP = {
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
    "100M": 100000000,
}

OPS = {
    "index_construction": {
        "description": "ScaNN AH index construction time (train + create_py_searcher)",
        "reference": "scann builder.tree.score_ah.reorder.create_py_searcher",
    },
    "batch_search_multithread": {
        "description": "Batch search at different OMP_NUM_THREADS settings",
        "reference": "searcher.search_batch with OMP thread control",
    },
    "leaves_parameter_sweep": {
        "description": "Search quality/speed trade-off at different leaves_to_search values",
        "reference": "search_batch leaves_to_search parameter sweep",
    },
    "serialization_save_load": {
        "description": "Index serialization (serialize/deserialize) throughput",
        "reference": "scann searcher.serialize / deserialize",
    },
}


def build_searcher(xb, d, n, k=10):
    num_leaves = max(100, n // 100)
    searcher = (
        scann.scann_ops_pybind.builder(xb, num_neighbors=k, distance_measure="squared_l2")
        .tree(num_leaves=num_leaves, num_leaves_to_search=num_leaves)
        .score_ah(2, anisotropic_quantization_threshold=0.2)
        .reorder(max(k, 100))
        .build()
    )
    return searcher, num_leaves


def bench_index_construction(xb, d, n, k=10, iterations=3):
    results = []
    for i in range(iterations):
        start = time.time()
        searcher, num_leaves = build_searcher(xb, d, n, k)
        elapsed = time.time() - start
        add_rate = n / elapsed if elapsed > 0 else 0
        results.append({"time_s": elapsed, "add_rate_per_sec": round(add_rate, 2)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_rate = round(sum(r["add_rate_per_sec"] for r in results) / len(results), 2)
    return avg_time, avg_rate, results


def bench_batch_search_multithread(searcher, xq, k, nq, iterations=3):
    thread_counts = [1, 2, 4, 8, "all"]
    all_results = {}
    for tc in thread_counts:
        label = f"threads_{tc}" if tc != "all" else "threads_all"
        if tc == "all":
            os.environ.pop("OMP_NUM_THREADS", None)
        else:
            os.environ["OMP_NUM_THREADS"] = str(tc)
        thread_results = []
        for i in range(iterations):
            start = time.time()
            searcher.search_batched(xq, final_num_neighbors=k, leaves_to_search=100)
            elapsed = time.time() - start
            qps = nq / elapsed if elapsed > 0 else 0
            thread_results.append({"time_s": elapsed, "qps": round(qps, 2)})
        avg_time = round(sum(r["time_s"] for r in thread_results) / len(thread_results), 4)
        avg_qps = round(sum(r["qps"] for r in thread_results) / len(thread_results), 2)
        all_results[label] = {"avg_time_s": avg_time, "avg_qps": avg_qps}
    return all_results


def bench_leaves_parameter_sweep(searcher, xb, d, n, k=10, iterations=3):
    nq = min(10000, n // 10)
    np.random.seed(123)
    xq = np.float32(np.random.random((nq, d)))

    xb_sq = np.einsum('ij,ij->i', xb, xb)
    gt_I = np.zeros((nq, k), dtype=np.int64)
    chunk = 1000
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        xq_chunk = xq[i:end]
        dots = np.dot(xq_chunk, xb.T)
        dists = xb_sq[None, :] + np.einsum('ij,ij->i', xq_chunk, xq_chunk)[:, None] - 2.0 * dots
        np.maximum(dists, 0, out=dists)
        gt_I[i:end] = np.argpartition(dists, k, axis=1)[:, :k]

    leaves_values = [10, 20, 50, 100, 200, 500, 1000]
    sweep_results = {}
    for leaves in leaves_values:
        runs = []
        for i in range(iterations):
            start = time.time()
            neighbors, dists = searcher.search_batched(
                xq, final_num_neighbors=k, leaves_to_search=leaves
            )
            elapsed = time.time() - start
            qps = nq / elapsed if elapsed > 0 else 0
            recall = 0.0
            for j in range(nq):
                recall += len(set(neighbors[j].tolist()) & set(gt_I[j].tolist())) / k
            recall /= nq
            runs.append({"qps": round(qps, 2), "recall": round(recall, 4), "time_s": elapsed})
        avg_qps = round(sum(r["qps"] for r in runs) / len(runs), 2)
        avg_recall = round(sum(r["recall"] for r in runs) / len(runs), 4)
        sweep_results[f"leaves_{leaves}"] = {"avg_qps": avg_qps, "avg_recall": avg_recall}
    return sweep_results


def bench_serialization(searcher, iterations=3):
    import tempfile
    import shutil
    results = []
    try:
        for i in range(iterations):
            tmpdir = tempfile.mkdtemp(prefix="scann_ser_")
            ser_start = time.time()
            searcher.serialize(tmpdir)
            ser_time = time.time() - ser_start
            ser_size = sum(os.path.getsize(os.path.join(tmpdir, f)) for f in os.listdir(tmpdir))

            deser_start = time.time()
            scann.scann_ops_pybind.load_searcher(tmpdir)
            deser_time = time.time() - deser_start
            shutil.rmtree(tmpdir, ignore_errors=True)

            results.append({
                "save_time_s": round(ser_time, 4),
                "load_time_s": round(deser_time, 4),
                "file_size_bytes": ser_size,
            })
        avg_save = round(sum(r["save_time_s"] for r in results) / len(results), 4)
        avg_load = round(sum(r["load_time_s"] for r in results) / len(results), 4)
        avg_size = round(sum(r["file_size_bytes"] for r in results) / len(results))
        return {"avg_save_time_s": avg_save, "avg_load_time_s": avg_load, "avg_file_size_bytes": avg_size}
    except Exception as e:
        return {"error": str(e)}


def main():
    parser = argparse.ArgumentParser(description='ScaNN Micro Benchmarks')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--data-scale', default='1M', choices=list(SCALE_MAP.keys()))
    parser.add_argument('--data-dim', type=int, default=128)
    parser.add_argument('--iterations', type=int, default=3)
    args = parser.parse_args()

    n = SCALE_MAP[args.data_scale]
    d = args.data_dim
    iterations = args.iterations
    k = 10

    print(f'[MICRO] Generating {n} vectors of dimension {d}...')
    np.random.seed(42)
    xb = np.float32(np.random.random((n, d)))

    all_results = {}

    print('[MICRO] Running index_construction...')
    avg_time, avg_rate, _ = bench_index_construction(xb, d, n, k, iterations)
    all_results["index_construction"] = {"avg_time_s": avg_time, "add_rate_per_sec": avg_rate}

    print('[MICRO] Building searcher for search benchmarks...')
    searcher, num_leaves = build_searcher(xb, d, n, k)
    nq = min(10000, n // 10)
    np.random.seed(123)
    xq = np.float32(np.random.random((nq, d)))

    print('[MICRO] Running batch_search_multithread...')
    mt_results = bench_batch_search_multithread(searcher, xq, k, nq, iterations)
    all_results["batch_search_multithread"] = mt_results

    print('[MICRO] Running leaves_parameter_sweep...')
    sweep_results = bench_leaves_parameter_sweep(searcher, xb, d, n, k, iterations)
    all_results["leaves_parameter_sweep"] = sweep_results

    print('[MICRO] Running serialization_save_load...')
    all_results["serialization_save_load"] = bench_serialization(searcher, iterations)

    output = {
        "benchmark": "micro_operations",
        "description": "Micro-level benchmarks for core ScaNN operations on ARM64",
        "reference": "ScaNN library (https://github.com/google-research/google-research/tree/master/scann)",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "add_rate": {
                "unit": "vectors/sec",
                "description": "Vector processing rate during ScaNN AH index training"
            },
            "search_qps": {
                "unit": "queries/sec",
                "description": "Batch search throughput at different thread counts"
            },
            "recall": {
                "unit": "ratio (0-1)",
                "description": "Search accuracy at different leaves_to_search values"
            },
            "serialization_time": {
                "unit": "seconds",
                "description": "Searcher serialize/deserialize time"
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
            "iterations": iterations
        },
        "results": all_results
    }

    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(output, f, indent=2)

    print(f'[MICRO] Results saved to: {args.output}')
    for name, res in all_results.items():
        print(f'[MICRO] {name}: {res}')
    print('[MICRO] Benchmark complete')


if __name__ == '__main__':
    main()
