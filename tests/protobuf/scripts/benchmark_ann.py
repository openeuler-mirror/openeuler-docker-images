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

MESSAGE_CONFIGS = {
    "SimpleMessage": {
        "description": "Simple message with 4 scalar fields (int32, string, float, bool)",
        "has_repeated": False,
        "has_nested": False,
    },
    "RepeatedInt32": {
        "description": "Message with repeated int32 field",
        "has_repeated": True,
        "has_nested": False,
        "repeated_field": "values",
    },
    "RepeatedString": {
        "description": "Message with repeated string field",
        "has_repeated": True,
        "has_nested": False,
        "repeated_field": "items",
    },
    "NestedMessage": {
        "description": "Message with nested sub-message and repeated nested fields",
        "has_repeated": True,
        "has_nested": True,
        "repeated_field": "subs",
    },
    "LargeMessage": {
        "description": "Large message with mixed scalar, repeated, and nested fields",
        "has_repeated": True,
        "has_nested": True,
        "repeated_field": "values",
    },
}

SIZE_VALUES = [10, 50, 100, 500, 1000]

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
            print('[ANN] protoc not found and grpc_tools not available')
            return False
    else:
        result = subprocess.run([
            protoc,
            '--proto_path', proto_dir,
            '--python_out', proto_dir,
            proto_file,
        ], capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            print(f'[ANN] protoc compilation failed: {result.stderr}')
            return False

    init_file = os.path.join(proto_dir, '__init__.py')
    if not os.path.exists(init_file):
        with open(init_file, 'w') as f:
            f.write('')

    return True

def create_message(pb2, config_name, size):
    if config_name == "SimpleMessage":
        msg = pb2.SimpleMessage()
        msg.id = 42
        msg.name = "test_message_name"
        msg.value = 3.14
        msg.flag = True
        return msg

    elif config_name == "RepeatedInt32":
        msg = pb2.RepeatedInt32()
        for i in range(size):
            msg.values.append(i)
        return msg

    elif config_name == "RepeatedString":
        msg = pb2.RepeatedString()
        for i in range(size):
            msg.items.append(f"item_{i}")
        return msg

    elif config_name == "NestedMessage":
        msg = pb2.NestedMessage()
        msg.id = 42
        msg.sub.sub_id = 1
        msg.sub.sub_name = "sub_test"
        msg.sub.sub_value = 2.71
        for i in range(size):
            sub = msg.subs.add()
            sub.sub_id = i
            sub.sub_name = f"sub_item_{i}"
            sub.sub_value = float(i) * 0.1
        return msg

    elif config_name == "LargeMessage":
        msg = pb2.LargeMessage()
        msg.id = 42
        msg.name = "large_test"
        for i in range(size):
            msg.values.append(i)
        msg.labels.append("label_a")
        msg.labels.append("label_b")
        for i in range(min(size, 10)):
            item = msg.items.add()
            item.sub_id = i
            item.sub_name = f"item_{i}"
            item.sub_value = float(i) * 0.5
        msg.score = 99.5
        msg.active = True
        return msg

def check_fidelity(original_msg, deserialized_msg):
    orig_bytes = original_msg.SerializeToString()
    new_bytes = deserialized_msg.SerializeToString()
    return 1.0 if orig_bytes == new_bytes else 0.0

def benchmark_config(pb2, config_name, config, size, num_messages, iterations):
    results = []
    msg_class_name = config_name
    msg_class = getattr(pb2, msg_class_name)

    for iteration in range(iterations):
        print(f'[ANN] {config_name} size={size} iteration {iteration+1}/{iterations}')

        original_msg = create_message(pb2, config_name, size)

        serialize_start = time.time()
        serialized_list = []
        for _ in range(num_messages):
            data = original_msg.SerializeToString()
            serialized_list.append(data)
        serialize_time = time.time() - serialize_start

        deserialize_start = time.time()
        for data in serialized_list:
            new_msg = msg_class()
            new_msg.ParseFromString(data)
        deserialize_time = time.time() - deserialize_start

        serialize_qps = num_messages / serialize_time if serialize_time > 0 else 0
        deserialize_qps = num_messages / deserialize_time if deserialize_time > 0 else 0
        serialize_latency_us = (serialize_time / num_messages) * 1e6 if num_messages > 0 else 0
        deserialize_latency_us = (deserialize_time / num_messages) * 1e6 if num_messages > 0 else 0
        serialized_size = len(original_msg.SerializeToString())

        new_msg_check = msg_class()
        new_msg_check.ParseFromString(serialized_list[0])
        fidelity = check_fidelity(original_msg, new_msg_check)

        result = {
            "iteration": iteration + 1,
            "serialize_time_s": round(serialize_time, 6),
            "deserialize_time_s": round(deserialize_time, 6),
            "serialize_qps": round(serialize_qps, 2),
            "deserialize_qps": round(deserialize_qps, 2),
            "serialize_latency_us": round(serialize_latency_us, 4),
            "deserialize_latency_us": round(deserialize_latency_us, 4),
            "serialized_size_bytes": serialized_size,
            "fidelity": fidelity,
            "size": size,
            "num_messages": num_messages,
        }
        results.append(result)

    avg_serialize_time = round(sum(r["serialize_time_s"] for r in results) / len(results), 6)
    avg_deserialize_time = round(sum(r["deserialize_time_s"] for r in results) / len(results), 6)
    avg_serialize_qps = round(sum(r["serialize_qps"] for r in results) / len(results), 2)
    avg_deserialize_qps = round(sum(r["deserialize_qps"] for r in results) / len(results), 2)
    avg_serialize_latency_us = round(sum(r["serialize_latency_us"] for r in results) / len(results), 4)
    avg_deserialize_latency_us = round(sum(r["deserialize_latency_us"] for r in results) / len(results), 4)
    avg_serialized_size = round(sum(r["serialized_size_bytes"] for r in results) / len(results))
    avg_fidelity = round(sum(r["fidelity"] for r in results) / len(results), 4)

    avg_results = {
        "avg_serialize_time_s": avg_serialize_time,
        "avg_deserialize_time_s": avg_deserialize_time,
        "avg_serialized_size_bytes": avg_serialized_size,
        "avg_size_sweep": {},
    }

    size_sweep = {}
    for size_val in SIZE_VALUES:
        sweep_results = []
        for iteration in range(iterations):
            sweep_msg = create_message(pb2, config_name, size_val)
            ser_start = time.time()
            for _ in range(num_messages):
                data = sweep_msg.SerializeToString()
            ser_elapsed = time.time() - ser_start

            deser_start = time.time()
            ser_data = sweep_msg.SerializeToString()
            for _ in range(num_messages):
                new_m = msg_class()
                new_m.ParseFromString(ser_data)
            deser_elapsed = time.time() - deser_start

            ser_qps = num_messages / ser_elapsed if ser_elapsed > 0 else 0
            deser_qps = num_messages / deser_elapsed if deser_elapsed > 0 else 0
            ser_lat_us = (ser_elapsed / num_messages) * 1e6 if num_messages > 0 else 0
            deser_lat_us = (deser_elapsed / num_messages) * 1e6 if num_messages > 0 else 0

            nm = msg_class()
            nm.ParseFromString(ser_data)
            fid = check_fidelity(sweep_msg, nm)

            sweep_results.append({
                "serialize_qps": round(ser_qps, 2),
                "deserialize_qps": round(deser_qps, 2),
                "serialize_latency_us": round(ser_lat_us, 4),
                "deserialize_latency_us": round(deser_lat_us, 4),
                "serialized_size_bytes": len(ser_data),
                "fidelity": fid,
            })

        avg_ser_qps = round(sum(r["serialize_qps"] for r in sweep_results) / len(sweep_results), 2)
        avg_deser_qps = round(sum(r["deserialize_qps"] for r in sweep_results) / len(sweep_results), 2)
        avg_ser_lat = round(sum(r["serialize_latency_us"] for r in sweep_results) / len(sweep_results), 4)
        avg_deser_lat = round(sum(r["deserialize_latency_us"] for r in sweep_results) / len(sweep_results), 4)
        avg_sz = round(sum(r["serialized_size_bytes"] for r in sweep_results) / len(sweep_results))
        avg_fid = round(sum(r["fidelity"] for r in sweep_results) / len(sweep_results), 4)

        size_sweep[size_val] = {
            "serialize_qps": avg_ser_qps,
            "deserialize_qps": avg_deser_qps,
            "serialize_latency_us": avg_ser_lat,
            "deserialize_latency_us": avg_deser_lat,
            "serialized_size_bytes": avg_sz,
            "fidelity": avg_fid,
        }

    avg_results["avg_size_sweep"] = size_sweep
    return avg_results, results

def main():
    parser = argparse.ArgumentParser(description='protobuf Serialization Benchmark')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--num-messages', type=int, default=10000)
    parser.add_argument('--iterations', type=int, default=1)
    args = parser.parse_args()

    num_messages = args.num_messages
    iterations = args.iterations

    proto_dir = tempfile.mkdtemp(prefix='protobuf_bench_')
    print(f'[ANN] Compiling proto definitions in {proto_dir}...')

    if not compile_proto(PROTO_CONTENT, proto_dir):
        print('[ANN] Proto compilation failed, using built-in protobuf types as fallback')
        try:
            from google.protobuf import descriptor_pb2 as pb2
            use_fallback = True
        except ImportError:
            print('[ANN] Cannot import any protobuf module')
            output = {
                "benchmark": "serialization_search",
                "error": "protobuf module not available",
                "results_summary": {},
            }
            os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
            with open(args.output, 'w') as f:
                json.dump(output, f, indent=2)
            return
    else:
        sys.path.insert(0, proto_dir)
        try:
            import perfbench_pb2 as pb2
            use_fallback = False
        except ImportError:
            print('[ANN] Cannot import compiled proto module, trying fallback')
            from google.protobuf import descriptor_pb2 as pb2
            use_fallback = True

    if use_fallback:
        MESSAGE_CONFIGS_FALLBACK = {
            "FileDescriptorProto_Small": {
                "description": "FileDescriptorProto with minimal fields (fallback benchmark)",
                "has_repeated": False,
                "has_nested": False,
            },
            "FileDescriptorProto_Repeated": {
                "description": "FileDescriptorProto with repeated fields (fallback benchmark)",
                "has_repeated": True,
                "has_nested": True,
                "repeated_field": "source_code_info",
            },
        }
        configs_to_benchmark = MESSAGE_CONFIGS_FALLBACK
    else:
        configs_to_benchmark = MESSAGE_CONFIGS

    all_results = {}
    detailed_results = {}

    for config_name, config in configs_to_benchmark.items():
        print(f'[ANN] Benchmarking {config_name}: {config["description"]}')
        try:
            avg, detailed = benchmark_config(
                pb2, config_name, config, 100, num_messages, iterations
            )
            all_results[config_name] = avg
            detailed_results[config_name] = detailed
        except Exception as e:
            print(f'[ANN] ERROR benchmarking {config_name}: {e}')
            import traceback
            traceback.print_exc()
            all_results[config_name] = {"error": str(e)}

    output = {
        "benchmark": "serialization_search",
        "description": "protobuf serialization/deserialization benchmark measuring throughput, latency, and fidelity",
        "reference": "https://github.com/protocolbuffers/protobuf",
        "timestamp": datetime.datetime.now().isoformat(),
        "performance_metrics": {
            "serialize_qps": {
                "unit": "messages/sec",
                "description": "Serialization throughput (messages per second)"
            },
            "deserialize_qps": {
                "unit": "messages/sec",
                "description": "Deserialization throughput (messages per second)"
            },
            "serialize_latency": {
                "unit": "microseconds",
                "description": "Average latency per message serialization"
            },
            "deserialize_latency": {
                "unit": "microseconds",
                "description": "Average latency per message deserialization"
            },
            "serialized_size": {
                "unit": "bytes",
                "description": "Binary serialized message size"
            },
            "fidelity": {
                "unit": "ratio (0-1)",
                "description": "Deserialized message matches original (1.0 = perfect fidelity)"
            }
        },
        "parameters": {
            "num_messages": num_messages,
            "iterations": iterations,
            "size_values": SIZE_VALUES,
            "message_configs": {name: cfg for name, cfg in configs_to_benchmark.items()}
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
            print(f'[ANN] {name}: SerQPS={res.get("avg_serialize_time_s", "N/A")}s, Size={res.get("avg_serialized_size_bytes", "N/A")}B')
            sweep = res.get("avg_size_sweep", {})
            for size_val, sweep_res in sweep.items():
                print(f'[ANN]   size={size_val}: SerQPS={sweep_res.get("serialize_qps", "N/A")}, DeserQPS={sweep_res.get("deserialize_qps", "N/A")}, Fidelity={sweep_res.get("fidelity", "N/A")}')
    print('[ANN] Benchmark complete')

    try:
        import shutil
        shutil.rmtree(proto_dir)
    except Exception:
        pass

if __name__ == '__main__':
    main()
