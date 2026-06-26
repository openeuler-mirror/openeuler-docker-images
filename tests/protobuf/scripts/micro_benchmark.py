#!/usr/bin/env python3
import json
import time
import argparse
import datetime
import os
import sys
import subprocess
import tempfile
import numpy as np
from concurrent.futures import ThreadPoolExecutor

def _serialize_worker(msg, count):
    for _ in range(count):
        msg.SerializeToString()
    return count

def _deserialize_worker(data, msg_class, count):
    for _ in range(count):
        m = msg_class()
        m.ParseFromString(data)
    return count

PROTO_CONTENT = '''
syntax = "proto3";
package perfbench;

message SimpleMessage {
  int32 id = 1;
  string name = 2;
  float value = 3;
  bool flag = 4;
}

message RepeatedInt32 {
  repeated int32 values = 1;
}

message RepeatedString {
  repeated string items = 1;
}

message SubMessage {
  int32 sub_id = 1;
  string sub_name = 2;
  float sub_value = 3;
}

message NestedMessage {
  int32 id = 1;
  SubMessage sub = 2;
  repeated SubMessage subs = 3;
}

message LargeMessage {
  int32 id = 1;
  string name = 2;
  repeated int32 values = 3;
  repeated string labels = 4;
  repeated SubMessage items = 5;
  float score = 6;
  bool active = 7;
}
'''

def compile_proto(proto_content, proto_dir):
    proto_file = os.path.join(proto_dir, 'perfbench.proto')
    with open(proto_file, 'w') as f:
        f.write(proto_content)

    protoc_paths = [
        '/usr/local/bin/protoc',
        '/usr/bin/protoc',
        'protoc',
    ]
    protoc = None
    for p in protoc_paths:
        try:
            result = subprocess.run([p, '--version'], capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                protoc = p
                break
        except Exception:
            continue

    if protoc is None:
        try:
            from grpc_tools import protoc as grpc_protoc
            grpc_protoc.main([
                f'--proto_path={proto_dir}',
                f'--python_out={proto_dir}',
                proto_file,
            ])
        except ImportError:
            return False
    else:
        result = subprocess.run([
            protoc,
            '--proto_path', proto_dir,
            '--python_out', proto_dir,
            proto_file,
        ], capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            return False

    init_file = os.path.join(proto_dir, '__init__.py')
    if not os.path.exists(init_file):
        with open(init_file, 'w') as f:
            f.write('')
    return True

def get_pb2_module(proto_dir):
    sys.path.insert(0, proto_dir)
    try:
        import perfbench_pb2 as pb2
        return pb2, False
    except ImportError:
        from google.protobuf import descriptor_pb2 as pb2
        return pb2, True

def create_simple_msg(pb2, use_fallback=False):
    if use_fallback:
        msg = pb2.FileDescriptorProto()
        msg.name = "test.proto"
        msg.package = "perfbench"
        return msg
    msg = pb2.SimpleMessage()
    msg.id = 42
    msg.name = "test_message"
    msg.value = 3.14
    msg.flag = True
    return msg

def create_medium_msg(pb2, use_fallback=False):
    if use_fallback:
        msg = pb2.FileDescriptorProto()
        msg.name = "medium_test.proto"
        msg.package = "perfbench"
        for i in range(100):
            dep = msg.dependency.add() if hasattr(msg, 'dependency') else msg.public_dependency.add()
            if hasattr(msg, 'dependency'):
                msg.dependency.append(f"dep_{i}.proto")
            else:
                msg.public_dependency.append(i)
        return msg
    msg = pb2.RepeatedInt32()
    for i in range(100):
        msg.values.append(i)
    return msg

def create_large_msg(pb2, use_fallback=False):
    if use_fallback:
        msg = pb2.FileDescriptorProto()
        msg.name = "large_test.proto"
        for i in range(1000):
            msg.dependency.append(f"dep_{i}.proto")
        return msg
    msg = pb2.NestedMessage()
    msg.id = 42
    msg.sub.sub_id = 1
    msg.sub.sub_name = "sub"
    msg.sub.sub_value = 2.71
    for i in range(100):
        sub = msg.subs.add()
        sub.sub_id = i
        sub.sub_name = f"item_{i}"
        sub.sub_value = float(i) * 0.1
    return msg

def bench_single_serialize(pb2, num_messages, iterations, use_fallback=False):
    msg = create_simple_msg(pb2, use_fallback)
    msg_class = type(msg)
    results = []
    for i in range(iterations):
        start = time.time()
        for _ in range(num_messages):
            data = msg.SerializeToString()
        elapsed = time.time() - start
        qps = num_messages / elapsed if elapsed > 0 else 0
        latency_us = (elapsed / num_messages) * 1e6 if num_messages > 0 else 0
        results.append({"time_s": elapsed, "qps": round(qps, 2), "latency_us": round(latency_us, 4)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 6)
    avg_qps = round(sum(r["qps"] for r in results) / len(results), 2)
    avg_lat = round(sum(r["latency_us"] for r in results) / len(results), 4)
    return {"avg_time_s": avg_time, "serialize_qps": avg_qps, "avg_latency_us": avg_lat}

def bench_single_deserialize(pb2, num_messages, iterations, use_fallback=False):
    msg = create_simple_msg(pb2, use_fallback)
    msg_class = type(msg)
    serialized = msg.SerializeToString()
    results = []
    for i in range(iterations):
        start = time.time()
        for _ in range(num_messages):
            new_msg = msg_class()
            new_msg.ParseFromString(serialized)
        elapsed = time.time() - start
        qps = num_messages / elapsed if elapsed > 0 else 0
        latency_us = (elapsed / num_messages) * 1e6 if num_messages > 0 else 0
        results.append({"time_s": elapsed, "qps": round(qps, 2), "latency_us": round(latency_us, 4)})
    avg_time = round(sum(r["time_s"] for r in results) / len(results), 6)
    avg_qps = round(sum(r["qps"] for r in results) / len(results), 2)
    avg_lat = round(sum(r["latency_us"] for r in results) / len(results), 4)
    return {"avg_time_s": avg_time, "deserialize_qps": avg_qps, "avg_latency_us": avg_lat}

def bench_multithread_serialize(pb2, num_messages, iterations, use_fallback=False):
    msg = create_medium_msg(pb2, use_fallback)
    thread_counts = [1, 2, 4, 8, os.cpu_count() or 4]
    thread_counts = sorted(set(thread_counts))
    all_results = {}

    for num_threads in thread_counts:
        label = f"threads_{num_threads}" if num_threads != (os.cpu_count() or 4) else "threads_all"
        per_thread = max(num_messages // num_threads, 100)
        thread_results = []
        for i in range(iterations):
            start = time.time()
            with ThreadPoolExecutor(max_workers=num_threads) as executor:
                futures = []
                for t in range(num_threads):
                    futures.append(executor.submit(_serialize_worker, msg, per_thread))
                total_msgs = 0
                for f in futures:
                    total_msgs += f.result()
            elapsed = time.time() - start
            qps = total_msgs / elapsed if elapsed > 0 else 0
            thread_results.append({"time_s": elapsed, "qps": round(qps, 2)})
        avg_time = round(sum(r["time_s"] for r in thread_results) / len(thread_results), 6)
        avg_qps = round(sum(r["qps"] for r in thread_results) / len(thread_results), 2)
        all_results[label] = {"avg_time_s": avg_time, "avg_qps": avg_qps}
    return all_results

def bench_multithread_deserialize(pb2, num_messages, iterations, use_fallback=False):
    msg = create_medium_msg(pb2, use_fallback)
    msg_class = type(msg)
    serialized = msg.SerializeToString()
    thread_counts = [1, 2, 4, 8, os.cpu_count() or 4]
    thread_counts = sorted(set(thread_counts))
    all_results = {}

    for num_threads in thread_counts:
        label = f"threads_{num_threads}" if num_threads != (os.cpu_count() or 4) else "threads_all"
        per_thread = max(num_messages // num_threads, 100)
        thread_results = []
        for i in range(iterations):
            start = time.time()
            with ThreadPoolExecutor(max_workers=num_threads) as executor:
                futures = []
                for t in range(num_threads):
                    futures.append(executor.submit(_deserialize_worker, serialized, msg_class, per_thread))
                total_msgs = 0
                for f in futures:
                    total_msgs += f.result()
            elapsed = time.time() - start
            qps = total_msgs / elapsed if elapsed > 0 else 0
            thread_results.append({"time_s": elapsed, "qps": round(qps, 2)})
        avg_time = round(sum(r["time_s"] for r in thread_results) / len(thread_results), 6)
        avg_qps = round(sum(r["qps"] for r in thread_results) / len(thread_results), 2)
        all_results[label] = {"avg_time_s": avg_time, "avg_qps": avg_qps}
    return all_results

def bench_json_serialization(pb2, num_messages, iterations, use_fallback=False):
    msg = create_simple_msg(pb2, use_fallback)
    msg_class = type(msg)
    results_bin = []
    results_json = []

    from google.protobuf.json_format import MessageToJson, Parse

    for i in range(iterations):
        bin_start = time.time()
        for _ in range(num_messages):
            data = msg.SerializeToString()
        bin_elapsed = time.time() - bin_start
        bin_qps = num_messages / bin_elapsed if bin_elapsed > 0 else 0

        json_start = time.time()
        for _ in range(num_messages):
            json_str = MessageToJson(msg)
        json_elapsed = time.time() - json_start
        json_qps = num_messages / json_elapsed if json_elapsed > 0 else 0

        results_bin.append({"time_s": bin_elapsed, "qps": round(bin_qps, 2)})
        results_json.append({"time_s": json_elapsed, "qps": round(json_qps, 2)})

    avg_bin_time = round(sum(r["time_s"] for r in results_bin) / len(results_bin), 6)
    avg_bin_qps = round(sum(r["qps"] for r in results_bin) / len(results_bin), 2)
    avg_json_time = round(sum(r["time_s"] for r in results_json) / len(results_json), 6)
    avg_json_qps = round(sum(r["qps"] for r in results_json) / len(results_json), 2)

    json_str = MessageToJson(msg)
    json_size = len(json_str)
    bin_size = len(msg.SerializeToString())

    return {
        "binary_serialize": {"avg_time_s": avg_bin_time, "avg_qps": avg_bin_qps},
        "json_serialize": {"avg_time_s": avg_json_time, "avg_qps": avg_json_qps},
        "binary_size_bytes": bin_size,
        "json_size_bytes": json_size,
        "size_ratio": round(json_size / bin_size, 2) if bin_size > 0 else 0,
    }

def bench_large_message(pb2, num_messages, iterations, use_fallback=False):
    msg = create_large_msg(pb2, use_fallback)
    msg_class = type(msg)
    results = []
    for i in range(iterations):
        ser_start = time.time()
        data = msg.SerializeToString()
        ser_elapsed = time.time() - ser_start

        deser_start = time.time()
        new_msg = msg_class()
        new_msg.ParseFromString(data)
        deser_elapsed = time.time() - deser_start

        batch_ser_start = time.time()
        for _ in range(num_messages):
            msg.SerializeToString()
        batch_ser_elapsed = time.time() - batch_ser_start
        batch_ser_qps = num_messages / batch_ser_elapsed if batch_ser_elapsed > 0 else 0

        results.append({
            "single_serialize_time_s": round(ser_elapsed, 6),
            "single_deserialize_time_s": round(deser_elapsed, 6),
            "batch_serialize_qps": round(batch_ser_qps, 2),
            "message_size_bytes": len(data),
        })

    avg_ser = round(sum(r["single_serialize_time_s"] for r in results) / len(results), 6)
    avg_deser = round(sum(r["single_deserialize_time_s"] for r in results) / len(results), 6)
    avg_qps = round(sum(r["batch_serialize_qps"] for r in results) / len(results), 2)
    avg_size = round(sum(r["message_size_bytes"] for r in results) / len(results))

    return {
        "avg_serialize_time_s": avg_ser,
        "avg_deserialize_time_s": avg_deser,
        "serialize_qps": avg_qps,
        "avg_message_size_bytes": avg_size,
    }

def bench_size_parameter_sweep(pb2, num_messages, iterations, use_fallback=False):
    size_values = [10, 50, 100, 500, 1000]
    sweep_results = {}
    for size in size_values:
        if use_fallback:
            msg = pb2.FileDescriptorProto()
            msg.name = f"sweep_{size}.proto"
            for i in range(size):
                msg.dependency.append(f"dep_{i}.proto")
            msg_class = pb2.FileDescriptorProto
        else:
            msg = pb2.RepeatedInt32()
            for i in range(size):
                msg.values.append(i)
            msg_class = pb2.RepeatedInt32

        size_runs = []
        for i in range(iterations):
            ser_start = time.time()
            for _ in range(num_messages):
                msg.SerializeToString()
            ser_elapsed = time.time() - ser_start
            ser_qps = num_messages / ser_elapsed if ser_elapsed > 0 else 0

            serialized = msg.SerializeToString()
            deser_start = time.time()
            for _ in range(num_messages):
                new_msg = msg_class()
                new_msg.ParseFromString(serialized)
            deser_elapsed = time.time() - deser_start
            deser_qps = num_messages / deser_elapsed if deser_elapsed > 0 else 0

            size_runs.append({
                "serialize_qps": round(ser_qps, 2),
                "deserialize_qps": round(deser_qps, 2),
                "time_s": ser_elapsed,
            })

        avg_ser_qps = round(sum(r["serialize_qps"] for r in size_runs) / len(size_runs), 2)
        avg_deser_qps = round(sum(r["deserialize_qps"] for r in size_runs) / len(size_runs), 2)
        sweep_results[f"size_{size}"] = {"avg_serialize_qps": avg_ser_qps, "avg_deserialize_qps": avg_deser_qps}
    return sweep_results

OPS = {
    "single_serialize": {
        "description": "Single message binary serialization throughput",
        "reference": "protobuf Message.SerializeToString()",
    },
    "single_deserialize": {
        "description": "Single message binary deserialization throughput",
        "reference": "protobuf Message.ParseFromString()",
    },
    "multithread_serialize": {
        "description": "Multi-threaded serialization at different thread counts",
        "reference": "protobuf SerializeToString with ThreadPoolExecutor",
    },
    "multithread_deserialize": {
        "description": "Multi-threaded deserialization at different thread counts",
        "reference": "protobuf ParseFromString with ThreadPoolExecutor",
    },
    "json_serialization": {
        "description": "Binary vs JSON serialization comparison",
        "reference": "protobuf MessageToJson / Parse (json_format)",
    },
    "large_message": {
        "description": "Large nested message serialization/deserialization",
        "reference": "protobuf NestedMessage with 100 sub-items",
    },
    "size_parameter_sweep": {
        "description": "Serialization/deserialization at different message sizes",
        "reference": "protobuf RepeatedInt32 with varying field counts",
    },
}

def main():
    parser = argparse.ArgumentParser(description='protobuf Micro Benchmarks')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--num-messages', type=int, default=10000)
    parser.add_argument('--iterations', type=int, default=1)
    args = parser.parse_args()

    num_messages = args.num_messages
    iterations = args.iterations

    proto_dir = tempfile.mkdtemp(prefix='protobuf_micro_')
    print(f'[MICRO] Compiling proto definitions in {proto_dir}...')

    compiled = compile_proto(PROTO_CONTENT, proto_dir)
    pb2, use_fallback = get_pb2_module(proto_dir) if compiled else (None, True)

    if pb2 is None:
        try:
            from google.protobuf import descriptor_pb2 as pb2
            use_fallback = True
        except ImportError:
            print('[MICRO] Cannot import any protobuf module')
            output = {
                "benchmark": "micro_operations",
                "error": "protobuf module not available",
                "results": {},
            }
            os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
            with open(args.output, 'w') as f:
                json.dump(output, f, indent=2)
            return

    print(f'[MICRO] Using protobuf module (fallback={use_fallback}), num_messages={num_messages}')

    all_results = {}

    print('[MICRO] Running single_serialize...')
    all_results["single_serialize"] = bench_single_serialize(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running single_deserialize...')
    all_results["single_deserialize"] = bench_single_deserialize(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running multithread_serialize...')
    all_results["multithread_serialize"] = bench_multithread_serialize(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running multithread_deserialize...')
    all_results["multithread_deserialize"] = bench_multithread_deserialize(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running json_serialization...')
    all_results["json_serialization"] = bench_json_serialization(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running large_message...')
    all_results["large_message"] = bench_large_message(pb2, num_messages, iterations, use_fallback)

    print('[MICRO] Running size_parameter_sweep...')
    all_results["size_parameter_sweep"] = bench_size_parameter_sweep(pb2, num_messages, iterations, use_fallback)

    output = {
        "benchmark": "micro_operations",
        "description": "Micro-level benchmarks for core protobuf serialization/deserialization operations on ARM64",
        "reference": "protobuf library (https://github.com/protocolbuffers/protobuf)",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "serialize_qps": {
                "unit": "messages/sec",
                "description": "Message serialization throughput"
            },
            "deserialize_qps": {
                "unit": "messages/sec",
                "description": "Message deserialization throughput"
            },
            "latency": {
                "unit": "microseconds",
                "description": "Per-message latency for serialization/deserialization"
            },
            "fidelity": {
                "unit": "ratio (0-1)",
                "description": "Deserialized message matches original"
            }
        },
        "parameters": {
            "num_messages": num_messages,
            "iterations": iterations,
            "use_fallback_types": use_fallback,
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

    try:
        import shutil
        shutil.rmtree(proto_dir)
    except Exception:
        pass

if __name__ == '__main__':
    main()
