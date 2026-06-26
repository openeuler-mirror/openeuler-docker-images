# 开源软件 ARM64 性能测试 SKILL

本文档是基于 faiss / hnswlib 在 openEuler 24.03 SP3 (aarch64) 上的源码编译构建 + 性能测试 + 测试结果输出全流程提炼的通用技能模板，可一键复用于其他开源软件。

---

## 1. 项目目录结构

项目目录仅允许以下三个条目，无其他文件或子目录：

```
<software>_test.sh          # 主测试脚本（唯一入口）
scripts/                     # Python 辅助脚本
  json_helper.py             # JSON 查询/写入工具（通用）
  benchmark_ann.py           # ANN 搜索基准（软件定制）
  micro_benchmark.py         # 微基准（软件定制）
  aggregate_results.py       # 结果聚合（通用框架）
  generate_summary.py        # 文本报告生成（通用框架）
results/                     # 测试产物（按版本隔离）
  <version>/                 # 如 0.8.0/、0.9.0/、1.14.3/
    version_info.json         # 11字段环境信息
    benchmark_ann.json        # ANN 基准数据
    micro_benchmark.json      # 微基准数据
    results.json              # 聚合结果
    results.txt               # 文本报告
    results.log               # 全流程日志
```

**禁止项：**
- 项目目录下不允许出现 `shunit2`（下载至 `/tmp`）
- 项目目录下不允许出现 `__pycache__`、`*.pyc`
- 不允许出现 `build_faiss.sh`、`faiss_src/`、`faiss_install/` 等构建中间产物（放 `/tmp`）
- 不允许生成 `results.html`（已删除 HTML 报告逻辑）
- `results/` 下不允许平铺文件（必须按版本号建子目录）

---

## 2. 主测试脚本 `<software>_test.sh`

### 2.1 脚本头部（配置变量）

```bash
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="<software>"                          # 如 faiss / hnswlib
SOFTWARE_VERSION="${SOFTWARE_VERSION:-<默认版本>}"    # 如 0.8.0 / 1.14.3
BUILD_METHOD="${BUILD_METHOD:-<默认构建方式>}"        # pip / source_build
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"       # 不读 /etc/os-release
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"          # Model 字段值
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"                           # 必须在 LOG_FILE 使用前创建
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

# 基准测试参数（软件定制）
DATA_SCALE="${DATA_SCALE:-1M}"       # 数据集规模
DATA_DIM="${DATA_DIM:-128}"          # 向量维度
ITERATIONS="${ITERATIONS:-1}"        # 重复次数
K_VALUE="${K_VALUE:-10}"             # 最近邻数量

# 性能阈值（软件定制）
MINIMUM_QPS="${MINIMUM_QPS:-100}"
MINIMUM_RECALL="${MINIMUM_RECALL:-0.90}"
MAXIMUM_LATENCY_US="${MAXIMUM_LATENCY_US:-5000}"
MINIMUM_ADD_RATE="${MINIMUM_ADD_RATE:-50000}"
```

**关键约束：**
- `RESULTS_DIR` 必须包含 `${SOFTWARE_VERSION}`，同版本重跑直接覆盖
- `TARGET_OS` 由脚本变量决定，不从 `/etc/os-release` 读取
- `BUILD_METHOD` 支持 `pip`（PyPI 可获取的版本）和 `source_build`（git clone 源码构建）
- 所有 `pip3 install` 必须加 `--break-system-packages`（应对 PEP 668）

### 2.2 通用工具函数

```bash
log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }

json_get()              { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists()     { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results()    { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge()    { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_latency_le()       { python3 "${JSON_HELPER}" "$1" latency_le "$2" "${@:3}"; }
json_avg_throughput()   { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_max_latency()      { python3 "${JSON_HELPER}" "$1" max_latency "${@:2}"; }
json_version()          { python3 "${JSON_HELPER}" "$1" version; }
json_contains()         { python3 "${JSON_HELPER}" "$1" contains "$2"; }

detect_os_name() { echo "${TARGET_OS}"; }

download_shunit2() {
    # 下载至 /tmp/shunit2_XXXXXX，不在项目目录创建 shunit2 文件
    local shunit2_tmpdir="$(mktemp -d /tmp/shunit2_XXXXXX)"
    SHUNIT2_PATH="${shunit2_tmpdir}/shunit2"
    # curl/wget 多镜像尝试...
    # 验证 grep -q "^SHUNIT_VERSION="
}

create_build_tmpdir() {
    BUILD_TMPDIR="$(mktemp -d /tmp/<software>_build_XXXXXX)"
}
cleanup_build_tmpdir() {
    if [ -n "${BUILD_TMPDIR}" ] && [ -d "${BUILD_TMPDIR}" ]; then
        rm -rf "${BUILD_TMPDIR}"
    fi
}
```

### 2.3 四阶段生命周期

#### Phase 1: 安装/构建

```bash
phase1_install() {
    log "PHASE1" "=== Phase 1: Install <software> v${SOFTWARE_VERSION} (${BUILD_METHOD}) ==="

    python3 -c "import <module>" 2>/dev/null && {
        log "PHASE1" "<software> already importable, skipping install"
        return 0
    }

    case "${BUILD_METHOD}" in
        pip)
            pip3 install --break-system-packages <pip-package>==${SOFTWARE_VERSION} ...
            ;;
        source_build)
            create_build_tmpdir
            git clone --branch v${SOFTWARE_VERSION} --depth 1 <repo-url> "${BUILD_TMPDIR}/<software>" ...
            # 方式A：cmake/make/make install + cp Python bindings (如 faiss)
            # 方式B：pip install . 从本地目录 (如 hnswlib)
            cleanup_build_tmpdir
            ;;
    esac

    python3 -c "import <module>" 2>/dev/null || { log "ERROR" "import failed"; return 1; }
}
```

**faiss 源码构建（方式A）：**
- git clone → cmake -DFAISS_ENABLE_GPU=OFF ... → make -j → make install
- Python bindings：`cp -r ${FAISS_INSTALL_DIR}/faiss → site-packages`（无 setup.py）
- 需要安装 cmake/swig 等构建依赖，有 OS 分支逻辑

**hnswlib 源码构建（方式B）：**
- git clone → `pip3 install --break-system-packages "${BUILD_TMPDIR}/hnswlib"`
- v0.9.0 未上 PyPI，必须用此方式；v0.8.0 及以前可用 pip 方式

**通用原则：**
- 构建中间产物全部放 `/tmp/<software>_build_XXXXXX`
- `cleanup_build_tmpdir` 仅在构建成功后执行，失败时保留便于调试

#### Phase 2: 收集版本信息

```bash
phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver numpy_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="${TARGET_MODEL}"
    arch="$(uname -m | tr -d '\n\t')"
    kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then
        local num_proc="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"
        cpu_model="ARM64 CPU (${num_proc} cores)"
    fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    numpy_ver="$(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"

    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${numpy_ver}"
}
```

**`write_version_info` 严格12个参数，生成11字段 JSON：**

| # | 参数名 | JSON字段 | 类型 | 来源 |
|---|---|---|---|---|
| 1 | timestamp | `test_time` | str | `date -u` |
| 2 | model | `Model` | str | `TARGET_MODEL` |
| 3 | arch | `architecture` | str | `uname -m` |
| 4 | kernel | `kernel` | str | `uname -r` |
| 5 | os_name | `os` | str | `TARGET_OS`（非/etc/os-release） |
| 6 | cpu_model | `cpu_model` | str | /proc/cpuinfo |
| 7 | cores | `cpu_cores` | int | `nproc` |
| 8 | sw_name | `software_name` | str | `SOFTWARE_NAME` |
| 9 | sw_version | `software_version` | str | `SOFTWARE_VERSION` |
| 10 | python_ver | `python_version` | str | `python3 --version` |
| 11 | numpy_ver | `numpy_version` | str | numpy.__version__ |

**已删除字段：** `memory_mb`, `install_method`, `installed`, `parallelism`, `hnswlib_version`, `neon_asimd_available`, `index_M`, `index_ef_construction`, `runtime_version`, `blas_status`, `faiss_version`, `build_method`, `build_os`

#### Phase 3: 运行基准测试

```bash
phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"

    python3 "${SCRIPT_DIR}/scripts/benchmark_ann.py" \
        --output "${RESULTS_DIR}/benchmark_ann.json" ...
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        --output "${RESULTS_DIR}/micro_benchmark.json" ...
}
```

**benchmark_ann.py 和 micro_benchmark.py 是软件定制的，需要根据被测软件的 API 编写。**

#### Phase 4: 聚合与报告

```bash
phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="
    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        --results-dir "${RESULTS_DIR}" --output "${RESULTS_DIR}/results.json"
    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
        "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.txt"
    # 不调用 generate_html_report.py，不生成 results.html
}
```

### 2.4 shUnit2 测试函数

**通用测试（所有软件必须有）：**

| 函数名 | 断言内容 |
|---|---|
| `testArchitectureIsARM64` | `uname -m` 为 aarch64 |
| `testSoftwareIsInstalled` | `python3 -c "import <module>"` 成功 |
| `testSoftwareVersionMatches` | 版本变量非空 |
| `testVersionInfoExists` | `version_info.json` 文件存在 |
| `testVersionInfoHasArchitecture` | `architecture` 字段存在 |
| `testVersionInfoHasSoftwareVersion` | `software_version` 字段存在 |
| `testBenchmark*ProducesResults` | 基准 JSON 文件存在 |
| `testBenchmark*HasRequiredFields` | JSON 包含 benchmark/performance_metrics/results_summary |
| `testBenchmark*ThroughputAboveThreshold` | QPS >= 阈值（使用 `json_throughput_ge`） |
| `testBenchmarkMicroProducesResults` | micro_benchmark.json 存在 |
| `testBenchmarkMicroAllOperationsCompleted` | `json_count_results` >= 4 |
| `testAggregatedResultsExist` | results.json 存在 |
| `testSummaryReportGenerated` | results.txt 存在 |
| `testLogFileGenerated` | results.log 存在 |
| `testAggregatedResultsContainsAllBenchmarks` | results.json 包含 ann + micro |

**软件定制测试（按需添加）：**

| 示例 | 说明 |
|---|---|
| `testBenchmarkANNRecallAboveThreshold` | Recall >= 阈值（hnswlib） |
| `testBenchmarkANNEfSweepCompleted` | ef 参数扫描完成（hnswlib） |
| `testBenchmarkMicroIndexConstructionRate` | 索引构建速率 >= 阈值（hnswlib） |
| `testBenchmarkMicroMultithreadScaling` | 多线程搜索数据存在（hnswlib） |
| `testBenchmarkMicroSearchLatencyBelowThreshold` | 单次搜索延迟 <= 阈值（faiss） |

**断言模式：**

```bash
testBenchmark*ThroughputAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local result
    result="$(json_throughput_ge "${bench_file}" "${MINIMUM_QPS}" <key_path>)"
    local actual
    actual="$(json_avg_throughput "${bench_file}" <key_path>)"
    echo "[DIAG] QPS: ${actual} (threshold: ${MINIMUM_QPS})"
    assertTrue "QPS should be >= ${MINIMUM_QPS}" "[ ${result} -eq 1 ]"
}
```

### 2.5 main() 和退出守卫

```bash
main() {
    local check_only=0
    while [ $# -gt 0 ]; do
        case "$1" in
            --check) check_only=1; shift ;;
            -h|--help) usage ;;
            *) log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done

    check_prerequisites || exit 1
    download_shunit2 || exit 1
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
```

---

## 3. Python 辅助脚本

### 3.1 json_helper.py（通用，跨软件复用）

**核心功能清单：**

| CLI 命令 | 函数 | 用途 |
|---|---|---|
| `get <keys>` | `cmd_get` | 按路径取值 |
| `field_exists <field>` | `cmd_field_exists` | 检查字段是否存在 |
| `count_results` | `cmd_count_results` | 计数 results/results_summary |
| `throughput_ge <threshold> <keys>` | `cmd_throughput_ge` | 值 >= 阈值 → 输出1/0 |
| `latency_le <threshold> <keys>` | `cmd_latency_le` | 值 <= 阈值 → 输出1/0 |
| `avg_throughput <keys>` | `cmd_avg_throughput` | 求平均值 |
| `max_latency <keys>` | `cmd_max_latency` | 求最大值 |
| `version` | `cmd_version` | 取 software_version |
| `contains <keyword>` | `cmd_contains` | JSON 文本包含关键词 → 输出1/0 |
| `write_version_info <12args>` | `cmd_write_version_info` | 写11字段 version_info.json |

**`cmd_write_version_info` 签名（严格12个参数）：**

```python
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
```

**关键修复：`throughput_ge` / `avg_throughput` fallback 路径剥离**

当 shell 调用 `throughput_ge 100 results_summary avg_ef_sweep 50 qps` 时，直接路径 `results_summary → avg_ef_sweep → 50 → qps` 因中间有 config_name 层级而失败。fallback 需剥离已匹配的顶层 key：

```python
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
                remaining_keys = keys[1:]  # 剥离 results_summary/results
                break
        if isinstance(rs, dict) and remaining_keys:
            for v in rs.values():
                if isinstance(v, dict):
                    val = get_nested(v, remaining_keys)
                    # ... 比较 float(val) >= float(threshold)
```

`cmd_latency_le`、`cmd_avg_throughput`、`cmd_max_latency` 同理。

### 3.2 aggregate_results.py（通用框架）

**职责：** 加载 `version_info.json` + `benchmark_ann.json` + `micro_benchmark.json` → 合并 + 计算摘要 → 写 `results.json`

```python
result = {
    "test_time": version_info.get("test_time", version_info.get("timestamp", ...)),
    "environment": version_info,
    "benchmarks": {"ann": ann_data, "micro": micro_data},
    "summary": summary,           # 按需计算
    "software": "<software>",
    "version": version_info.get("software_version", "<default>"),
}
```

**兼容性：** `test_time` 优先读取，fallback 读取旧 `timestamp`。

### 3.3 generate_summary.py（通用框架）

**职责：** 读取 `results.json` → 生成格式化文本报告 `results.txt`

**通用章节结构：**
1. Environment（Model/Architecture/OS/Kernel/CPU/Cores/Version/Python/NumPy）
2. ANN Search Benchmark（参数、每个配置的 QPS/Recall/BuildTime）
3. Micro Benchmarks（每个操作的速率/延迟/缩放）
4. Overall Summary（聚合指标）
5. 报告标题/Footer 由 `SOFTWARE_NAME` 变量决定

**调用方式：** 位置参数 `generate_summary.py <input_json> <output_file>`

### 3.4 benchmark_ann.py / micro_benchmark.py（软件定制）

这两个脚本需要根据被测软件的 Python API 编写，无通用模板。但输出 JSON 需遵循以下结构：

**benchmark_ann.json 结构：**

```json
{
  "benchmark": "ann_search",
  "performance_metrics": { "qps": {...}, "recall_at_k": {...} },
  "parameters": { "num_vectors": ..., "dimension": ..., "k": ..., "ef_search_values": [...] },
  "results_summary": {
    "<config_name>": {
      "avg_build_time_s": ...,
      "avg_index_size_bytes": ...,
      "avg_ef_sweep": { "50": { "qps": ..., "recall_at_10": ... } }
    }
  }
}
```

**micro_benchmark.json 结构：**

```json
{
  "benchmark": "micro_operations",
  "parameters": { "num_vectors": ..., "dimension": ..., "iterations": ... },
  "results": {
    "index_construction": { "avg_time_s": ..., "add_rate_per_sec": ... },
    "batch_search_multithread": { "threads_1": {...}, "threads_all": {...} }
  }
}
```

**必须包含的顶层字段：** `benchmark`、`performance_metrics`、`results_summary`/`results`

---

## 4. 版本切换与多版本共存

### 环境变量驱动版本切换

```bash
# hnswlib 0.8.0 (pip安装)
SOFTWARE_VERSION=0.8.0 BUILD_METHOD=pip ./hnswlib_test.sh

# hnswlib 0.9.0 (源码构建，未上PyPI)
SOFTWARE_VERSION=0.9.0 BUILD_METHOD=source_build ./hnswlib_test.sh

# faiss 1.14.3 (源码构建)
SOFTWARE_VERSION=1.14.3 ./faiss_test.sh

# faiss 1.14.2 (源码构建)
SOFTWARE_VERSION=1.14.2 ./faiss_test.sh
```

### results 目录版本隔离

```
results/
  0.7.0/   ← hnswlib 0.7.0  全部6个文件
  0.8.0/   ← hnswlib 0.8.0  全部6个文件
  0.9.0/   ← hnswlib 0.9.0  全部6个文件
  1.14.2/  ← faiss 1.14.2   全部6个文件
  1.14.3/  ← faiss 1.14.3   全部6个文件
```

- 同版本重跑直接覆盖对应子目录
- 不同版本互不影响

---

## 5. 一键生成新软件测试脚本流程

### 步骤清单

1. **确认软件信息**
   - 软件名（SOFTWARE_NAME）和 pip 包名
   - 默认版本号（SOFTWARE_VERSION）
   - 构建方式：pip 可获取 → `pip`；需要源码 → `source_build`
   - Python 模块名（`import <module>`）
   - Git 仓库地址和版本 tag 格式（`v0.8.0` 或 `0.8.0`）

2. **创建目录结构**
   ```bash
   mkdir -p /path/test/<software>/scripts
   touch /path/test/<software>/<software>_test.sh
   chmod +x /path/test/<software>/<software>_test.sh
   ```

3. **复制通用文件**
   - 从现有项目复制 `scripts/json_helper.py`（无需修改）
   - 从现有项目复制 `scripts/aggregate_results.py`（修改 `software` 字段名和 benchmark key 名）
   - 从现有项目复制 `scripts/generate_summary.py`（修改报告标题/Footer、数据路径 `benchmarks.ann` vs `primary_benchmark`）

4. **编写 `<software>_test.sh`**
   - 按第 2 模板填写配置变量
   - 编写 `phase1_install()`：pip 或 source_build 或两者兼有
   - `phase2_verify()` 直接复用模板（仅改 `python3 -c "import <module>"`）
   - `phase3_run_benchmarks()` 调用定制基准脚本
   - `phase4_results()` 直接复用模板
   - 测试函数按第 2.4 节填写通用 + 定制测试

5. **编写 `benchmark_ann.py`**
   - 根据软件 API 实现索引构建 + 搜索 + Recall 计算
   - 输出 JSON 遵循第 3.4 节结构
   - 必须包含 `benchmark`、`performance_metrics`、`results_summary` 字段

6. **编写 `micro_benchmark.py`**
   - 根据软件 API 实现索引构建速率、搜索延迟、多线程、序列化等
   - 输出 JSON 遵循第 3.4 节结构
   - 必须包含 `benchmark`、`results` 字段

7. **设置性能阈值**
   - 先用小数据集（DATA_SCALE=10K）跑一遍看实际值
   - 根据实际值调整 MINIMUM_QPS / MINIMUM_RECALL 等阈值
   - 大数据集（1M）的阈值通常更高

8. **验证**
   ```bash
   DATA_SCALE=10K ITERATIONS=1 SOFTWARE_VERSION=<ver> BUILD_METHOD=<method> ./<software>_test.sh
   ```
   - 确认 18+ 测试 pass
   - 确认 `version_info.json` 11 字段正确（os="openEuler 24.03 SP3"、Model="Kunpeng-920"）
   - 确认 `results/<version>/` 下有 6 个文件，无 `results.html`

---

## 6. 常见陷阱与注意事项

| 陷阱 | 解决方案 |
|---|---|
| `LOG_FILE` tee 报错 "No such file or directory" | `mkdir -p "${RESULTS_DIR}"` 必须在定义 `LOG_FILE` 之后立即执行 |
| `write_version_info` 参数个数不匹配 | 严格12个参数：timestamp, model, arch, kernel, os_name, cpu_model, cores, sw_name, sw_version, python_ver, numpy_ver |
| `json_throughput_ge` 在嵌套 results_summary 中返回 0 | fallback 需剥离顶层 key（keys[1:]），否则 get_nested(v, full_keys) 在子 dict 中找不到 |
| pip install 被 PEP 668 阻止 | 所有 `pip3 install` 加 `--break-system-packages` |
| hnswlib 无 `__version__` 属性 | 不依赖运行时版本检查，使用 `SOFTWARE_VERSION` 环境变量 |
| faiss Python bindings 无 setup.py | 从 `make install` 后的 install dir `cp -r faiss → site-packages` |
| v0.9.0 未上 PyPI | 必须用 `BUILD_METHOD=source_build`：git clone + `pip install .` |
| shunit2 下载至项目目录 | 下载至 `/tmp/shunit2_XXXXXX`，项目目录不允许出现 shunit2 文件 |
| 构建中间产物留在项目目录 | 全部放 `/tmp/<software>_build_XXXXXX`，成功后 cleanup |
| `results/` 平铺文件 | 必须按版本建子目录 `results/<version>/` |
| `__pycache__` 出现 | 运行后 `rm -rf scripts/__pycache__` |
| ANN 基准大数据集超时 | ground truth 是 nq×nb 暴力搜索，10K 约1分钟，1M 约1小时 |
