#!/usr/bin/env python3
import json
import time
import argparse
import datetime
import os
import pickle
import numpy as np
import hnswlib

SCALE_MAP = {
    "10K": 10000,
    "100K": 100000,
    "1M": 1000000,
    "10M": 10000000,
    "100M": 100000000,
}

OPS = {
    "index_construction": {
        "description": "HNSW index construction time (init + add_items)",
        "reference": "hnswlib Index.init_index + add_items",
    },
    "incremental_insert": {
        "description": "Incremental insertion: add vectors in small batches",
        "reference": "hnswlib add_items with partial data",
    },
    "batch_search_multithread": {
        "description": "Multi-threaded batch search at different thread counts",
        "reference": "hnswlib knn_query num_threads parameter",
    },
    "serialization_save_load": {
        "description": "Index serialization (save/load) throughput",
        "reference": "hnswlib save_index / load_index",
    },
    "pickle_serialization": {
        "description": "Python pickle serialization/deserialization",
        "reference": "hnswlib pickle support",
    },
    "ef_parameter_sweep": {
        "description": "Search quality/speed trade-off at different ef values",
        "reference": "hnswlib set_ef parameter sweep",
    },
}

def bench_index_construction(xb, d, n, iterations=3):
    results = []
    for i in range(iterations):
        index = hnswlib.Index(space='l2', dim=d)
        index.init_index(max_elements=n, ef_construction=200, M=16)
        start = time.time()
        index.add_items(xb, np.arange(n), num_threads=-1)
        elapsed = time.time() - start
        add_rate = n / elapsed if elapsed > 0 else 0
        results.append({"time_s": elapsed, "add_rate_per_sec": round(add_rate, 2)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_rate = round(sum(r["add_rate_per_sec"] for r in results) / len(results), 2)
    return avg_time, avg_rate, results

def bench_incremental_insert(d, n, iterations=3):
    results = []
    batch_size = min(n // 10, 100000)
    for i in range(iterations):
        index = hnswlib.Index(space='l2', dim=d)
        index.init_index(max_elements=n, ef_construction=200, M=16)
        np.random.seed(42)
        xb = np.float32(np.random.random((n, d)))
        start = time.time()
        for batch_start in range(0, n, batch_size):
            batch_end = min(batch_start + batch_size, n)
            batch_data = xb[batch_start:batch_end]
            batch_ids = np.arange(batch_start, batch_end)
            index.add_items(batch_data, batch_ids, num_threads=-1)
        elapsed = time.time() - start
        add_rate = n / elapsed if elapsed > 0 else 0
        results.append({"time_s": elapsed, "add_rate_per_sec": round(add_rate, 2), "batch_size": batch_size})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 4)
    avg_rate = round(sum(r["add_rate_per_sec"] for r in results) / len(results), 2)
    return avg_time, avg_rate, results

def bench_batch_search_multithread(xb, d, n, iterations=3):
    index = hnswlib.Index(space='l2', dim=d)
    index.init_index(max_elements=n, ef_construction=200, M=16)
    index.add_items(xb, np.arange(n), num_threads=-1)
    nq = min(10000, n // 10)
    np.random.seed(123)
    xq = np.float32(np.random.random((nq, d)))

    thread_counts = [1, 2, 4, 8, -1]
    all_results = {}
    for num_threads in thread_counts:
        label = f"threads_{num_threads}" if num_threads != -1 else "threads_all"
        thread_results = []
        for i in range(iterations):
            index.set_ef(100)
            start = time.time()
            labels, dists = index.knn_query(xq, k=10, num_threads=num_threads)
            elapsed = time.time() - start
            qps = nq / elapsed if elapsed > 0 else 0
            thread_results.append({"time_s": elapsed, "qps": round(qps, 2)})
        avg_time = round(sum(r["time_s"] for r in thread_results) / len(thread_results), 4)
        avg_qps = round(sum(r["qps"] for r in thread_results) / len(thread_results), 2)
        all_results[label] = {"avg_time_s": avg_time, "avg_qps": avg_qps}
    return all_results

def bench_serialization_save_load(xb, d, n, iterations=3):
    index = hnswlib.Index(space='l2', dim=d)
    index.init_index(max_elements=n, ef_construction=200, M=16)
    index.add_items(xb, np.arange(n), num_threads=-1)
    index_path = '/tmp/hnsw_bench_serialization.bin'

    results = []
    for i in range(iterations):
        save_start = time.time()
        index.save_index(index_path)
        save_time = time.time() - save_start
        file_size = os.path.getsize(index_path)

        new_index = hnswlib.Index(space='l2', dim=d)
        load_start = time.time()
        new_index.load_index(index_path, max_elements=n)
        load_time = time.time() - load_start

        results.append({
            "save_time_s": round(save_time, 4),
            "load_time_s": round(load_time, 4),
            "file_size_bytes": file_size,
        })

    avg_save = round(sum(r["save_time_s"] for r in results) / len(results), 4)
    avg_load = round(sum(r["load_time_s"] for r in results) / len(results), 4)
    avg_size = round(sum(r["file_size_bytes"] for r in results) / len(results))
    os.remove(index_path)
    return avg_save, avg_load, avg_size, results

def bench_pickle_serialization(xb, d, n, iterations=3):
    index = hnswlib.Index(space='l2', dim=d)
    index.init_index(max_elements=n, ef_construction=200, M=16)
    index.add_items(xb, np.arange(n), num_threads=-1)
    index.set_ef(50)

    results = []
    for i in range(iterations):
        pickle_start = time.time()
        data = pickle.dumps(index)
        pickle_time = time.time() - pickle_start

        unpickle_start = time.time()
        index_copy = pickle.loads(data)
        unpickle_time = time.time() - unpickle_start

        results.append({
            "pickle_time_s": round(pickle_time, 4),
            "unpickle_time_s": round(unpickle_time, 4),
            "pickle_size_bytes": len(data),
        })

    avg_pickle = round(sum(r["pickle_time_s"] for r in results) / len(results), 4)
    avg_unpickle = round(sum(r["unpickle_time_s"] for r in results) / len(results), 4)
    avg_size = round(sum(r["pickle_size_bytes"] for r in results) / len(results))
    return avg_pickle, avg_unpickle, avg_size, results

def bench_ef_parameter_sweep(xb, d, n, k=10, iterations=3):
    index = hnswlib.Index(space='l2', dim=d)
    index.init_index(max_elements=n, ef_construction=200, M=16)
    index.add_items(xb, np.arange(n), num_threads=-1)
    nq = min(10000, n // 10)
    np.random.seed(123)
    xq = np.float32(np.random.random((nq, d)))

    gt_I = np.zeros((nq, k), dtype=np.int64)
    chunk = 1000
    for i in range(0, nq, chunk):
        end = min(i + chunk, nq)
        dists = np.sum((xq[i:end].reshape(end - i, 1, -1) - xb.reshape(1, n, -1)) ** 2, axis=2)
        gt_I[i:end] = np.argsort(dists, axis=1)[:, :k]

    ef_values = [10, 20, 50, 100, 200, 500, 1000]
    sweep_results = {}
    for ef in ef_values:
        ef_runs = []
        for i in range(iterations):
            index.set_ef(ef)
            start = time.time()
            labels, dists = index.knn_query(xq, k=k, num_threads=-1)
            elapsed = time.time() - start
            qps = nq / elapsed if elapsed > 0 else 0
            recall = 0.0
            for j in range(nq):
                recall += len(set(labels[j].tolist()) & set(gt_I[j].tolist())) / k
            recall /= nq
            ef_runs.append({"qps": round(qps, 2), "recall": round(recall, 4), "time_s": elapsed})
        avg_qps = round(sum(r["qps"] for r in ef_runs) / len(ef_runs), 2)
        avg_recall = round(sum(r["recall"] for r in ef_runs) / len(ef_runs), 4)
        sweep_results[f"ef_{ef}"] = {"avg_qps": avg_qps, "avg_recall": avg_recall}
    return sweep_results

def main():
    parser = argparse.ArgumentParser(description='hnswlib Micro Benchmarks')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--data-scale', default='1M', choices=list(SCALE_MAP.keys()))
    parser.add_argument('--data-dim', type=int, default=128)
    parser.add_argument('--iterations', type=int, default=3)
    args = parser.parse_args()

    n = SCALE_MAP[args.data_scale]
    d = args.data_dim
    iterations = args.iterations

    print(f'[MICRO] Generating {n} vectors of dimension {d}...')
    np.random.seed(42)
    xb = np.float32(np.random.random((n, d)))

    all_results = {}

    print('[MICRO] Running index_construction...')
    avg_time, avg_rate, detailed = bench_index_construction(xb, d, n, iterations=iterations)
    all_results["index_construction"] = {"avg_time_s": avg_time, "add_rate_per_sec": avg_rate}

    print('[MICRO] Running incremental_insert...')
    avg_time, avg_rate, detailed = bench_incremental_insert(d, n, iterations=iterations)
    all_results["incremental_insert"] = {"avg_time_s": avg_time, "add_rate_per_sec": avg_rate}

    print('[MICRO] Running batch_search_multithread...')
    mt_results = bench_batch_search_multithread(xb, d, n, iterations=iterations)
    all_results["batch_search_multithread"] = mt_results

    print('[MICRO] Running serialization_save_load...')
    avg_save, avg_load, avg_size, detailed = bench_serialization_save_load(xb, d, n, iterations=iterations)
    all_results["serialization_save_load"] = {
        "avg_save_time_s": avg_save,
        "avg_load_time_s": avg_load,
        "avg_file_size_bytes": avg_size,
    }

    print('[MICRO] Running pickle_serialization...')
    avg_pickle, avg_unpickle, avg_size, detailed = bench_pickle_serialization(xb, d, n, iterations=iterations)
    all_results["pickle_serialization"] = {
        "avg_pickle_time_s": avg_pickle,
        "avg_unpickle_time_s": avg_unpickle,
        "avg_pickle_size_bytes": avg_size,
    }

    print('[MICRO] Running ef_parameter_sweep...')
    sweep_results = bench_ef_parameter_sweep(xb, d, n, iterations=iterations)
    all_results["ef_parameter_sweep"] = sweep_results

    output = {
        "benchmark": "micro_operations",
        "description": "Micro-level benchmarks for core hnswlib operations on ARM64",
        "reference": "hnswlib library (https://github.com/nmslib/hnswlib)",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "add_rate": {
                "unit": "vectors/sec",
                "description": "Vector insertion rate into HNSW index"
            },
            "search_qps": {
                "unit": "queries/sec",
                "description": "Batch search throughput at different thread counts"
            },
            "recall": {
                "unit": "ratio (0-1)",
                "description": "Search accuracy at different ef_search values"
            },
            "serialization_time": {
                "unit": "seconds",
                "description": "Index save/load time"
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