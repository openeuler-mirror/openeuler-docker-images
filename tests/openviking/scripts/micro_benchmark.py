#!/usr/bin/env python3
import json
import os
import sys
import time
import threading
import importlib


def run_micro_benchmark(output_file, iterations):
    results = {}

    t0 = time.perf_counter()
    try:
        import openviking
        ov_version = openviking.__version__
    except Exception as e:
        ov_version = "unknown"
        print(f"[BENCHMARK_MICRO] Import error: {e}")
    t1 = time.perf_counter()
    import_time_ms = round((t1 - t0) * 1000, 3)

    t0 = time.perf_counter()
    try:
        importlib.reload(openviking)
    except Exception:
        pass
    t1 = time.perf_counter()
    reload_time_ms = round((t1 - t0) * 1000, 3)

    results["import_init"] = {
        "import_time_ms": import_time_ms,
        "reload_time_ms": reload_time_ms,
        "version": ov_version
    }

    try:
        from openviking.pyagfs import get_binding_client
        BindingClient, FileHandle = get_binding_client()

        t0 = time.perf_counter()
        client = BindingClient()
        t1 = time.perf_counter()
        client_init_ms = round((t1 - t0) * 1000, 3)

        t0 = time.perf_counter()
        health_result = client.health()
        t1 = time.perf_counter()
        health_time_ms = round((t1 - t0) * 1000, 3)

        t0 = time.perf_counter()
        caps = client.get_capabilities()
        t1 = time.perf_counter()
        capabilities_time_ms = round((t1 - t0) * 1000, 3)

        results["client_init"] = {
            "client_init_ms": client_init_ms,
            "health_check_ms": health_time_ms,
            "get_capabilities_ms": capabilities_time_ms,
            "health_result": str(health_result),
            "capabilities_info": str(caps)[:200] if caps else "N/A"
        }

        mount_path = "viking://micro_bench/"
        client.mount("memfs", mount_path)
        try:
            client.mkdir(mount_path, mode="755")
        except Exception:
            pass

        fs_ops = {}
        test_data_1kb = os.urandom(1024)
        test_data_64kb = os.urandom(65536)
        test_data_1mb = os.urandom(1048576)
        data_configs = {
            "1kb": (test_data_1kb, 1024),
            "64kb": (test_data_64kb, 65536),
            "1mb": (test_data_1mb, 1048576),
        }

        for size_name, (data, size) in data_configs.items():
            op_times = {}
            for op_name in ["write", "read", "stat", "ls", "rm"]:
                latencies = []
                write_path = None
                for i in range(iterations):
                    file_path = f"{mount_path}{size_name}_micro_{i}.bin"
                    if op_name == "write":
                        t0 = time.perf_counter()
                        client.write(file_path, data)
                        t1 = time.perf_counter()
                        latencies.append((t1 - t0) * 1000)
                        write_path = file_path
                    elif op_name == "read":
                        if write_path is None:
                            continue
                        t0 = time.perf_counter()
                        client.read(write_path)
                        t1 = time.perf_counter()
                        latencies.append((t1 - t0) * 1000)
                    elif op_name == "stat":
                        if write_path is None:
                            continue
                        t0 = time.perf_counter()
                        client.stat(write_path)
                        t1 = time.perf_counter()
                        latencies.append((t1 - t0) * 1000)
                    elif op_name == "ls":
                        t0 = time.perf_counter()
                        client.ls(mount_path)
                        t1 = time.perf_counter()
                        latencies.append((t1 - t0) * 1000)
                    elif op_name == "rm":
                        t0 = time.perf_counter()
                        try:
                            client.rm(file_path)
                        except Exception:
                            pass
                        t1 = time.perf_counter()
                        latencies.append((t1 - t0) * 1000)

                if latencies:
                    avg_lat = round(sum(latencies) / len(latencies), 3)
                    ops_sec = round(len(latencies) * 1000 / sum(latencies), 2) if sum(latencies) > 0 else 0
                    throughput = round(size / (avg_lat / 1000) / (1024 * 1024), 2) if avg_lat > 0 else 0
                    op_times[f"{op_name}_avg_latency_ms"] = avg_lat
                    op_times[f"{op_name}_ops_per_sec"] = ops_sec
                    if op_name in ("write", "read"):
                        op_times[f"{op_name}_throughput_mbs"] = throughput

            fs_ops[size_name] = op_times

        results["fs_ops_latency"] = fs_ops

        mt_results = {}
        mt_data = os.urandom(65536)
        thread_counts = [1, 2, 4, 8, 32]

        for tc in thread_counts:
            per_thread_ops = max(1, 50 // tc)
            thread_results = []

            def run_and_capture(tid, cnt):
                local_ops = 0
                local_time = 0.0
                for j in range(cnt):
                    path = f"{mount_path}mt_{tc}_{tid}_{j}.bin"
                    t0 = time.perf_counter()
                    try:
                        client.write(path, mt_data)
                    except Exception:
                        pass
                    t1 = time.perf_counter()
                    local_time += (t1 - t0) * 1000
                    local_ops += 1
                    try:
                        client.rm(path)
                    except Exception:
                        pass
                thread_results.append((local_ops, local_time))

            t_start = time.perf_counter()
            threads_list = []
            for tid in range(tc):
                t = threading.Thread(target=run_and_capture, args=(tid, per_thread_ops))
                threads_list.append(t)
                t.start()
            for t in threads_list:
                t.join()
            t_end = time.perf_counter()

            ops_completed = sum(r[0] for r in thread_results)
            total_time_ms = sum(r[1] for r in thread_results)
            wall_time_ms = round((t_end - t_start) * 1000, 3)
            combined_ops_sec = round(ops_completed * 1000 / wall_time_ms, 2) if wall_time_ms > 0 else 0
            avg_per_op_latency = round(total_time_ms / ops_completed, 3) if ops_completed > 0 else 0

            mt_results[f"threads_{tc}"] = {
                "total_ops": ops_completed,
                "wall_time_ms": wall_time_ms,
                "combined_ops_per_sec": combined_ops_sec,
                "avg_per_op_latency_ms": avg_per_op_latency
            }

        results["multithread_fs_ops"] = mt_results

        try:
            client.rm(mount_path, recursive=True)
        except Exception:
            pass
        try:
            client.unmount(mount_path)
        except Exception:
            pass

    except Exception as e:
        print(f"[BENCHMARK_MICRO] AGFS client error: {e}")
        results["client_init"] = {
            "client_init_ms": 0,
            "health_check_ms": 0,
            "get_capabilities_ms": 0,
            "error": str(e)
        }

    output = {
        "benchmark": "micro_operations",
        "description": "OpenViking micro benchmarks: import/init latency, filesystem ops, multithread scaling on ARM64",
        "reference": "https://github.com/volcengine/OpenViking",
        "software": "openviking",
        "architecture": "arm64",
        "performance_metrics": {
            "ops_per_sec": {"unit": "ops/s", "description": "Operations per second"},
            "avg_latency_ms": {"unit": "ms", "description": "Average latency in milliseconds"},
            "init_time_ms": {"unit": "ms", "description": "Initialization time"}
        },
        "parameters": {
            "iterations": iterations,
            "data_sizes": [1024, 65536, 1048576],
            "thread_counts": [1, 2, 4, 8, 32]
        },
        "results": results
    }

    with open(output_file, "w") as f:
        json.dump(output, f, indent=2)
    print(f"[BENCHMARK_MICRO] Output written to {output_file}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: micro_benchmark.py <output_file> <iterations>")
        sys.exit(1)

    output_file = sys.argv[1]
    iterations = int(sys.argv[2])
    run_micro_benchmark(output_file, iterations)
