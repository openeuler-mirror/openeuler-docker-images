#!/usr/bin/env python3
import json
import sys
import os
from datetime import datetime, timezone


def load_json(filepath):
    with open(filepath, "r") as f:
        return json.load(f)


def save_json(filepath, data):
    with open(filepath, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=True)


def get_nested(data, keys):
    for key in keys:
        if isinstance(data, dict) and key in data:
            data = data[key]
        elif isinstance(data, list) and key.isdigit():
            data = data[int(key)]
        else:
            return None
    return data


def cmd_get(filepath, *keys):
    data = load_json(filepath)
    result = get_nested(data, keys)
    if result is None:
        print("NULL")
    else:
        print(result)


def cmd_field_exists(filepath, field):
    data = load_json(filepath)
    if isinstance(data, dict):
        print(1 if field in data else 0)
    elif isinstance(data, list):
        print(1 if any(field in item for item in data if isinstance(item, dict)) else 0)
    else:
        print(0)


def cmd_count_results(filepath):
    data = load_json(filepath)
    if isinstance(data, dict) and "results" in data:
        print(len(data["results"]))
    elif isinstance(data, dict) and "results_summary" in data:
        rs = data["results_summary"]
        if isinstance(rs, dict):
            print(len(rs))
        elif isinstance(rs, list):
            print(len(rs))
        else:
            print(0)
    elif isinstance(data, list):
        print(len(data))
    else:
        print(0)


def cmd_throughput_ge(filepath, threshold, *keys):
    data = load_json(filepath)
    value = get_nested(data, keys)
    if value is None:
        rs_keys = ["results_summary", "results"]
        rs = None
        remaining_keys = keys
        for rk in rs_keys:
            if rk in data:
                rs = data[rk]
                remaining_keys = keys[1:]
                break
        if isinstance(rs, dict) and remaining_keys:
            for v in rs.values():
                if isinstance(v, dict):
                    val = get_nested(v, remaining_keys)
                    if val is not None:
                        try:
                            if float(val) >= float(threshold):
                                print(1)
                                return
                        except (ValueError, TypeError):
                            pass
        print(0)
    else:
        try:
            print(1 if float(value) >= float(threshold) else 0)
        except (ValueError, TypeError):
            print(0)


def cmd_latency_le(filepath, threshold, *keys):
    data = load_json(filepath)
    value = get_nested(data, keys)
    if value is None:
        rs_keys = ["results_summary", "results"]
        rs = None
        remaining_keys = keys
        for rk in rs_keys:
            if rk in data:
                rs = data[rk]
                remaining_keys = keys[1:]
                break
        if isinstance(rs, dict) and remaining_keys:
            for v in rs.values():
                if isinstance(v, dict):
                    val = get_nested(v, remaining_keys)
                    if val is not None:
                        try:
                            if float(val) <= float(threshold):
                                print(1)
                                return
                        except (ValueError, TypeError):
                            pass
        print(0)
    else:
        try:
            print(1 if float(value) <= float(threshold) else 0)
        except (ValueError, TypeError):
            print(0)


def cmd_version(filepath):
    data = load_json(filepath)
    if isinstance(data, dict):
        ver = data.get("software_version", data.get("version", "unknown"))
        print(ver)
    else:
        print("unknown")


def cmd_contains(filepath, keyword):
    with open(filepath, "r") as f:
        content = f.read()
    print(1 if keyword in content else 0)


def cmd_avg_throughput(filepath, *keys):
    data = load_json(filepath)
    results = data.get("results", [])
    if not results:
        rs_keys = ["results_summary", "results"]
        rs = None
        remaining_keys = keys
        for rk in rs_keys:
            if rk in data:
                rs = data[rk]
                if keys and keys[0] == rk:
                    remaining_keys = keys[1:]
                break
        if isinstance(rs, dict) and remaining_keys:
            values = []
            for v in rs.values():
                if isinstance(v, dict):
                    val = get_nested(v, remaining_keys)
                    if val is not None:
                        try:
                            values.append(float(val))
                        except (ValueError, TypeError):
                            pass
            if values:
                print(sum(values) / len(values))
            else:
                print(0)
            return
        top_val = get_nested(data, keys)
        if top_val is not None:
            try:
                print(float(top_val))
                return
            except (ValueError, TypeError):
                pass
        print(0)
        return
    values = []
    for r in results:
        val = get_nested(r, keys)
        if val is not None:
            try:
                values.append(float(val))
            except (ValueError, TypeError):
                pass
    if values:
        print(sum(values) / len(values))
    else:
        print(0)


def cmd_max_latency(filepath, *keys):
    data = load_json(filepath)
    results = data.get("results", [])
    if not results:
        rs_keys = ["results_summary", "results"]
        rs = None
        remaining_keys = keys
        for rk in rs_keys:
            if rk in data:
                rs = data[rk]
                if keys and keys[0] == rk:
                    remaining_keys = keys[1:]
                break
        if isinstance(rs, dict) and remaining_keys:
            values = []
            for v in rs.values():
                if isinstance(v, dict):
                    val = get_nested(v, remaining_keys)
                    if val is not None:
                        try:
                            values.append(float(val))
                        except (ValueError, TypeError):
                            pass
            if values:
                print(max(values))
            else:
                print(0)
            return
        top_val = get_nested(data, keys)
        if top_val is not None:
            try:
                print(float(top_val))
                return
            except (ValueError, TypeError):
                pass
        print(0)
        return
    values = []
    for r in results:
        val = get_nested(r, keys)
        if val is not None:
            try:
                values.append(float(val))
            except (ValueError, TypeError):
                pass
    if values:
        print(max(values))
    else:
        print(0)


def cmd_write_version_info(filepath, timestamp, model, arch, kernel, os_name, cpu_model,
                           cores, sw_name, sw_version, python_ver, numpy_ver):
    data = {
        "test_time": str(timestamp),
        "Model": str(model),
        "architecture": str(arch),
        "kernel": str(kernel),
        "os": str(os_name),
        "cpu_model": str(cpu_model),
        "cpu_cores": int(cores),
        "software_name": str(sw_name),
        "software_version": str(sw_version),
        "python_version": str(python_ver),
        "numpy_version": str(numpy_ver)
    }
    save_json(filepath, data)


def main():
    if len(sys.argv) < 3:
        print("Usage: json_helper.py <filepath> <command> [args...]")
        sys.exit(1)

    filepath = sys.argv[1]
    command = sys.argv[2]
    args = sys.argv[3:]

    commands = {
        "get": lambda: cmd_get(filepath, *args),
        "field_exists": lambda: cmd_field_exists(filepath, args[0] if args else ""),
        "count_results": lambda: cmd_count_results(filepath),
        "throughput_ge": lambda: cmd_throughput_ge(filepath, args[0], *args[1:]),
        "latency_le": lambda: cmd_latency_le(filepath, args[0], *args[1:]),
        "version": lambda: cmd_version(filepath),
        "contains": lambda: cmd_contains(filepath, args[0] if args else ""),
        "write_version_info": lambda: cmd_write_version_info(filepath, *args),
        "avg_throughput": lambda: cmd_avg_throughput(filepath, *args),
        "max_latency": lambda: cmd_max_latency(filepath, *args),
    }

    if command not in commands:
        print(f"Unknown command: {command}")
        sys.exit(1)

    commands[command]()


if __name__ == "__main__":
    main()
