#!/usr/bin/env python3
import json
import os
import sys
import time
import tempfile
import shutil


def get_binding_client():
    try:
        from openviking.pyagfs import get_binding_client
        BindingClient, FileHandle = get_binding_client()
        return BindingClient, FileHandle
    except Exception as e:
        print(f"[BENCHMARK_CONTEXT] Failed to get binding client: {e}")
        return None, None


def run_context_fs_benchmark(output_file, iterations):
    BindingClient, FileHandle = get_binding_client()
    if BindingClient is None:
        print("[BENCHMARK_CONTEXT] Cannot get AGFS binding client, writing minimal results")
        minimal = {
            "benchmark": "context_fs",
            "description": "OpenViking AGFS filesystem operations benchmark on ARM64",
            "reference": "https://github.com/volcengine/OpenViking",
            "software": "openviking",
            "architecture": "arm64",
            "performance_metrics": {
                "ops_per_sec": {"unit": "ops/s", "description": "Filesystem operations per second"},
                "avg_latency_ms": {"unit": "ms", "description": "Average operation latency"},
                "throughput_mbs": {"unit": "MB/s", "description": "Data throughput"}
            },
            "parameters": {"iterations": iterations, "data_size_bytes": 0},
            "results_summary": {}
        }
        with open(output_file, "w") as f:
            json.dump(minimal, f, indent=2)
        return

    client = BindingClient()
    mount_path = "viking://benchmark/"

    try:
        client.mount("memfs", mount_path)
        try:
            client.mkdir(mount_path, mode="755")
        except Exception:
            pass

        results_summary = {}
        data_sizes = {
            "small_1kb": 1024,
            "medium_64kb": 65536,
            "large_1mb": 1048576,
        }

        for size_name, data_size in data_sizes.items():
            test_data = os.urandom(data_size)
            test_path = f"{mount_path}{size_name}_data.bin"
            times = {"write": [], "read": [], "stat": [], "ls": [], "rm": [], "mkdir": [], "grep": []}
            write_bytes_list = []
            read_bytes_list = []

            for i in range(iterations):
                file_path = f"{mount_path}{size_name}_file_{i}.bin"

                t0 = time.perf_counter()
                try:
                    client.write(file_path, test_data)
                except Exception as e:
                    print(f"[BENCHMARK_CONTEXT] Write error: {e}")
                    continue
                t1 = time.perf_counter()
                times["write"].append((t1 - t0) * 1000)
                write_bytes_list.append(data_size)

                t0 = time.perf_counter()
                try:
                    read_result = client.read(file_path)
                except Exception as e:
                    print(f"[BENCHMARK_CONTEXT] Read error: {e}")
                    continue
                t1 = time.perf_counter()
                times["read"].append((t1 - t0) * 1000)
                read_bytes_list.append(len(read_result) if isinstance(read_result, (bytes, str)) else data_size)

                t0 = time.perf_counter()
                try:
                    client.stat(file_path)
                except Exception:
                    pass
                t1 = time.perf_counter()
                times["stat"].append((t1 - t0) * 1000)

                t0 = time.perf_counter()
                try:
                    client.ls(mount_path)
                except Exception:
                    pass
                t1 = time.perf_counter()
                times["ls"].append((t1 - t0) * 1000)

                t0 = time.perf_counter()
                try:
                    client.rm(file_path)
                except Exception:
                    pass
                t1 = time.perf_counter()
                times["rm"].append((t1 - t0) * 1000)

            dir_path = f"{mount_path}{size_name}_dir/"
            mkdir_times = []
            for i in range(iterations):
                test_dir = f"{dir_path}subdir_{i}/"
                t0 = time.perf_counter()
                try:
                    client.mkdir(test_dir, mode="755")
                except Exception:
                    pass
                t1 = time.perf_counter()
                mkdir_times.append((t1 - t0) * 1000)
                try:
                    client.rm(test_dir, recursive=True)
                except Exception:
                    pass
            times["mkdir"] = mkdir_times

            grep_data = b"hello world benchmark test openviking context " * (data_size // 40 + 1)
            grep_path = f"{mount_path}{size_name}_grep_data.bin"
            try:
                client.write(grep_path, grep_data[:data_size])
            except Exception:
                pass
            grep_times = []
            for _ in range(iterations):
                t0 = time.perf_counter()
                try:
                    client.grep(grep_path, "benchmark", case_insensitive=True)
                except Exception:
                    pass
                t1 = time.perf_counter()
                grep_times.append((t1 - t0) * 1000)
            times["grep"] = grep_times
            try:
                client.rm(grep_path)
            except Exception:
                pass

            size_results = {}
            total_write_bytes = sum(write_bytes_list) if write_bytes_list else 0
            total_write_time_ms = sum(times["write"]) if times["write"] else 0

            size_results["write_avg_latency_ms"] = round(sum(times["write"]) / len(times["write"]), 3) if times["write"] else 0
            size_results["write_ops_per_sec"] = round(len(times["write"]) * 1000 / sum(times["write"]), 2) if times["write"] and sum(times["write"]) > 0 else 0
            size_results["write_throughput_mbs"] = round(total_write_bytes / (total_write_time_ms / 1000) / (1024 * 1024), 2) if total_write_time_ms > 0 else 0

            total_read_bytes = sum(read_bytes_list) if read_bytes_list else 0
            total_read_time_ms = sum(times["read"]) if times["read"] else 0
            size_results["read_avg_latency_ms"] = round(sum(times["read"]) / len(times["read"]), 3) if times["read"] else 0
            size_results["read_ops_per_sec"] = round(len(times["read"]) * 1000 / sum(times["read"]), 2) if times["read"] and sum(times["read"]) > 0 else 0
            size_results["read_throughput_mbs"] = round(total_read_bytes / (total_read_time_ms / 1000) / (1024 * 1024), 2) if total_read_time_ms > 0 else 0

            size_results["stat_avg_latency_ms"] = round(sum(times["stat"]) / len(times["stat"]), 3) if times["stat"] else 0
            size_results["stat_ops_per_sec"] = round(len(times["stat"]) * 1000 / sum(times["stat"]), 2) if times["stat"] and sum(times["stat"]) > 0 else 0
            size_results["ls_avg_latency_ms"] = round(sum(times["ls"]) / len(times["ls"]), 3) if times["ls"] else 0
            size_results["ls_ops_per_sec"] = round(len(times["ls"]) * 1000 / sum(times["ls"]), 2) if times["ls"] and sum(times["ls"]) > 0 else 0
            size_results["rm_avg_latency_ms"] = round(sum(times["rm"]) / len(times["rm"]), 3) if times["rm"] else 0
            size_results["rm_ops_per_sec"] = round(len(times["rm"]) * 1000 / sum(times["rm"]), 2) if times["rm"] and sum(times["rm"]) > 0 else 0
            size_results["mkdir_avg_latency_ms"] = round(sum(times["mkdir"]) / len(times["mkdir"]), 3) if times["mkdir"] else 0
            size_results["mkdir_ops_per_sec"] = round(len(times["mkdir"]) * 1000 / sum(times["mkdir"]), 2) if times["mkdir"] and sum(times["mkdir"]) > 0 else 0
            size_results["grep_avg_latency_ms"] = round(sum(times["grep"]) / len(times["grep"]), 3) if times["grep"] else 0
            size_results["grep_ops_per_sec"] = round(len(times["grep"]) * 1000 / sum(times["grep"]), 2) if times["grep"] and sum(times["grep"]) > 0 else 0
            size_results["data_size_bytes"] = data_size

            results_summary[size_name] = size_results

        overall_write_ops = 0
        overall_write_lat = 0
        write_count = 0
        for sn, sr in results_summary.items():
            if sr.get("write_ops_per_sec", 0) > 0:
                overall_write_ops += sr["write_ops_per_sec"]
                overall_write_lat += sr.get("write_avg_latency_ms", 0)
                write_count += 1
        if write_count > 0:
            results_summary["write_ops_per_sec"] = round(overall_write_ops / write_count, 2)
            results_summary["write_avg_latency_ms"] = round(overall_write_lat / write_count, 3)

        overall_read_ops = 0
        overall_read_lat = 0
        read_count = 0
        for sn, sr in results_summary.items():
            if sn.startswith("small") or sn.startswith("medium") or sn.startswith("large"):
                if sr.get("read_ops_per_sec", 0) > 0:
                    overall_read_ops += sr["read_ops_per_sec"]
                    overall_read_lat += sr.get("read_avg_latency_ms", 0)
                    read_count += 1
        if read_count > 0:
            results_summary["read_ops_per_sec"] = round(overall_read_ops / read_count, 2)
            results_summary["read_avg_latency_ms"] = round(overall_read_lat / read_count, 3)

        output = {
            "benchmark": "context_fs",
            "description": "OpenViking AGFS filesystem operations benchmark on ARM64",
            "reference": "https://github.com/volcengine/OpenViking",
            "software": "openviking",
            "architecture": "arm64",
            "performance_metrics": {
                "ops_per_sec": {"unit": "ops/s", "description": "Filesystem operations per second"},
                "avg_latency_ms": {"unit": "ms", "description": "Average operation latency"},
                "throughput_mbs": {"unit": "MB/s", "description": "Data throughput in megabytes per second"}
            },
            "parameters": {
                "iterations": iterations,
                "data_sizes_bytes": [1024, 65536, 1048576],
                "operations": ["write", "read", "stat", "ls", "rm", "mkdir", "grep"]
            },
            "results_summary": results_summary
        }

        with open(output_file, "w") as f:
            json.dump(output, f, indent=2)
        print(f"[BENCHMARK_CONTEXT] Output written to {output_file}")

    finally:
        try:
            client.rm(mount_path, recursive=True)
        except Exception:
            pass
        try:
            client.unmount(mount_path)
        except Exception:
            pass


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: benchmark_context.py <output_file> <iterations>")
        sys.exit(1)

    output_file = sys.argv[1]
    iterations = int(sys.argv[2])
    run_context_fs_benchmark(output_file, iterations)
