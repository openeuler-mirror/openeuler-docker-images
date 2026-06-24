#!/usr/bin/env python3
import json
import sys
import os


def safe_int(val):
    if isinstance(val, int):
        return val
    if isinstance(val, float):
        return int(val)
    s = str(val).strip()
    if s.startswith('0x') or s.startswith('0X'):
        try:
            return int(s, 16)
        except ValueError:
            return 0
    try:
        return int(float(s))
    except (ValueError, TypeError):
        return 0


def safe_float(val):
    if isinstance(val, (int, float)):
        return float(val)
    s = str(val).strip()
    try:
        return float(s)
    except (ValueError, TypeError):
        return 0.0


class JsonHelper:
    def __init__(self, filepath):
        self.filepath = filepath
        self.data = None
        if os.path.exists(filepath):
            with open(filepath, 'r') as f:
                self.data = json.load(f)

    def _navigate(self, data, keys):
        if not keys:
            return data
        key = keys[0]
        rest = keys[1:]
        if isinstance(data, dict):
            if key in data:
                return self._navigate(data[key], rest)
            values = []
            for sub_key, sub_val in data.items():
                if isinstance(sub_val, dict):
                    try:
                        val = self._navigate(sub_val, keys)
                        if val is not None:
                            if isinstance(val, (int, float)):
                                values.append(val)
                            elif isinstance(val, dict):
                                for v in val.values():
                                    if isinstance(v, (int, float)):
                                        values.append(v)
                    except (KeyError, TypeError):
                        pass
            if values:
                return values
            return None
        elif isinstance(data, list):
            results = []
            for item in data:
                try:
                    val = self._navigate(item, keys)
                    if val is not None:
                        if isinstance(val, list):
                            results.extend(val)
                        else:
                            results.append(val)
                except (KeyError, TypeError):
                    pass
            return results if results else None
        return None

    def get(self, *keys):
        val = self._navigate(self.data, list(keys))
        if val is None:
            print("N/A")
            return
        if isinstance(val, list):
            print(json.dumps(val))
        elif isinstance(val, dict):
            print(json.dumps(val))
        else:
            print(val)

    def field_exists(self, field):
        if self.data is None:
            print(0)
            return
        if field in self.data:
            print(1)
            return
        for key, val in self.data.items():
            if isinstance(val, dict) and field in val:
                print(1)
                return
        print(0)

    def count_results(self):
        if self.data is None:
            print(0)
            return
        for key in ('results', 'results_summary', 'results_detailed'):
            if key in self.data:
                obj = self.data[key]
                if isinstance(obj, list):
                    print(len(obj))
                    return
                if isinstance(obj, dict):
                    print(len(obj))
                    return
        print(0)

    def _collect_numeric(self, data, keys):
        val = self._navigate(data, list(keys))
        if val is None:
            return []
        if isinstance(val, (int, float)):
            return [float(val)]
        if isinstance(val, list):
            nums = []
            for v in val:
                if isinstance(v, (int, float)):
                    nums.append(float(v))
                elif isinstance(v, dict):
                    for dv in v.values():
                        if isinstance(dv, (int, float)):
                            nums.append(float(dv))
            return nums
        if isinstance(val, dict):
            nums = []
            for v in val.values():
                if isinstance(v, (int, float)):
                    nums.append(float(v))
            return nums
        return []

    def throughput_ge(self, threshold, *keys):
        nums = self._collect_numeric(self.data, list(keys))
        if not nums:
            print(0)
            return
        result = 1 if any(n >= safe_float(threshold) for n in nums) else 0
        print(result)

    def latency_le(self, threshold, *keys):
        nums = self._collect_numeric(self.data, list(keys))
        if not nums:
            print(0)
            return
        result = 1 if any(n <= safe_float(threshold) for n in nums) else 0
        print(result)

    def avg_throughput(self, *keys):
        nums = self._collect_numeric(self.data, list(keys))
        if not nums:
            print("N/A")
            return
        avg = sum(nums) / len(nums)
        print(f"{avg:.2f}")

    def max_latency(self, *keys):
        nums = self._collect_numeric(self.data, list(keys))
        if not nums:
            print("N/A")
            return
        print(f"{max(nums):.2f}")

    def version(self):
        if self.data is None:
            print("unknown")
            return
        for key in ('software_version', 'hnswlib_version', 'version', 'hnswlib_expected_version'):
            if key in self.data:
                print(self.data[key])
                return
        print("unknown")

    def contains(self, keyword):
        if self.data is None:
            print(0)
            return
        text = json.dumps(self.data)
        print(1 if keyword in text else 0)

    def write_version_info(self, args, extra=None, output=None):
        if len(args) < 12:
            print("[ERROR] write_version_info requires at least 12 positional args")
            sys.exit(1)

        timestamp = args[0]
        arch = args[1]
        kernel = args[2]
        os_name = args[3]
        cpu_model = args[4]
        cores = safe_int(args[5])
        mem_mb = safe_int(args[6])
        software_name = args[7]
        software_version = args[8]
        runtime_version = args[9]
        install_method = args[10]
        found = safe_int(args[11])
        parallelism = safe_int(args[12]) if len(args) > 12 else cores

        info = {
            "timestamp": timestamp,
            "architecture": arch,
            "kernel": kernel,
            "os": os_name,
            "cpu_model": cpu_model,
            "cores": cores,
            "memory_mb": mem_mb,
            "software_name": software_name,
            "software_version": software_version,
            "runtime_version": runtime_version,
            "install_method": install_method,
            "installed": found,
            "parallelism": parallelism,
        }

        if extra:
            for kv in extra:
                if '=' in kv:
                    k, v = kv.split('=', 1)
                    try:
                        v_num = float(v)
                        if v_num == int(v_num):
                            info[k] = int(v_num)
                        else:
                            info[k] = v_num
                    except ValueError:
                        info[k] = v

        out_path = output if output else self.filepath
        with open(out_path, 'w') as f:
            json.dump(info, f, indent=2)
        print(f"[VERSION_INFO] Saved to {out_path}")


def main():
    if len(sys.argv) < 3:
        print("Usage: json_helper.py <file> <command> [args...]")
        sys.exit(1)

    filepath = sys.argv[1]
    command = sys.argv[2]

    helper = JsonHelper(filepath)

    if command == 'get':
        helper.get(*sys.argv[3:])
    elif command == 'field_exists':
        helper.field_exists(sys.argv[3])
    elif command == 'count_results':
        helper.count_results()
    elif command == 'throughput_ge':
        helper.throughput_ge(sys.argv[3], *sys.argv[4:])
    elif command == 'latency_le':
        helper.latency_le(sys.argv[3], *sys.argv[4:])
    elif command == 'avg_throughput':
        helper.avg_throughput(*sys.argv[3:])
    elif command == 'max_latency':
        helper.max_latency(*sys.argv[3:])
    elif command == 'version':
        helper.version()
    elif command == 'contains':
        helper.contains(sys.argv[3])
    elif command == 'write_version_info':
        extra = []
        output = None
        rest_args = []
        i = 3
        while i < len(sys.argv):
            if sys.argv[i] == '--extra':
                i += 1
                while i < len(sys.argv) and not sys.argv[i].startswith('--'):
                    extra.append(sys.argv[i])
                    i += 1
            elif sys.argv[i] == '--output':
                i += 1
                output = sys.argv[i]
                i += 1
            else:
                rest_args.append(sys.argv[i])
                i += 1
        helper.write_version_info(rest_args, extra=extra, output=output)
    else:
        print(f"[ERROR] Unknown command: {command}")
        sys.exit(1)


if __name__ == '__main__':
    main()
