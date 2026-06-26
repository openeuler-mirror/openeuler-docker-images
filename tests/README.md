# 开源软件 ARM64 性能测试框架

面向 openEuler 24.03 SP3 (aarch64/Kunpeng-920) 的开源软件源码编译构建 + 性能基准测试 + 结果输出一体化框架。当前已适配 **faiss** 和 **hnswlib**，可通过 SKILL.md 模板一键扩展至其他软件。

---

## 一、如何使用 SKILL

### 1.1 已适配软件 — 直接运行

```bash
# faiss 1.14.3（默认源码构建）
SOFTWARE_VERSION=1.14.3 ./faiss_test.sh

# faiss 1.14.2
SOFTWARE_VERSION=1.14.2 ./faiss_test.sh

# hnswlib 0.8.0（pip 安装）
SOFTWARE_VERSION=0.8.0 BUILD_METHOD=pip ./hnswlib_test.sh

# hnswlib 0.9.0（源码构建，未上 PyPI）
SOFTWARE_VERSION=0.9.0 BUILD_METHOD=source_build ./hnswlib_test.sh

# hnswlib 0.7.0（pip 安装）
SOFTWARE_VERSION=0.7.0 BUILD_METHOD=pip ./hnswlib_test.sh
```

**可调参数：**

| 环境变量 | 默认值 | 说明 |
|---|---|---|
| `SOFTWARE_VERSION` | 0.8.0 / 1.14.3 | 被测软件版本号 |
| `BUILD_METHOD` | pip / source_build | 构建方式：pip 从 PyPI 安装，source_build 从 git clone 源码构建 |
| `DATA_SCALE` | 1M / 100K | 数据集规模（10K/100K/1M/10M） |
| `DATA_DIM` | 128 | 向量维度 |
| `ITERATIONS` | 1 | 重复次数 |
| `K_VALUE` | 10 | 最近邻数量 k |
| `TARGET_OS` | openEuler 24.03 SP3 | 结果中显示的 OS 名称（不从系统读取） |
| `TARGET_MODEL` | Kunpeng-920 | 结果中显示的硬件型号 |

**快速验证建议：** 先用 `DATA_SCALE=10K` 跑一遍确认脚本无误（约1分钟），再用 `DATA_SCALE=1M` 正式基准（约1小时）。

### 1.2 扩展新软件 — 参照 SKILL.md

SKILL.md 是从 faiss/hnswlib 适配经验提炼的通用技能模板，包含完整的脚本结构、字段定义、构建流程和陷阱清单。

**使用方式：**

1. **直接对话** — 在 opencode 中说"为 `<软件名>` 创建性能测试脚本"，opencode 会自动加载 SKILL 生成
2. **手动参照** — 阅读 `SKILL.md` 第5章"一键生成新软件测试脚本流程"，按8步清单操作
3. **opencode skill** — 已注册为 `arm64-perf-test` skill，触发关键词：性能测试、benchmark、test.sh、version_info、source_build、openEuler

**扩展8步清单：**

| 步骤 | 操作 | 产出 |
|---|---|---|
| 1 | 确认软件名、pip包名、版本、构建方式、Python模块名、Git仓库 | 软件信息表 |
| 2 | 创建 `<软件>/scripts/` 目录 | 目录骨架 |
| 3 | 复制通用文件 json_helper.py、aggregate_results.py、generate_summary.py | 3个通用脚本 |
| 4 | 编写 `<软件>_test.sh` | 主测试脚本 |
| 5 | 编写 `benchmark_ann.py` | ANN基准脚本 |
| 6 | 编写 `micro_benchmark.py` | 微基准脚本 |
| 7 | DATA_SCALE=10K 试跑，调整阈值 | 阈值校准 |
| 8 | 正式验证，确认18+测试pass | 完整结果 |

---

## 二、目录架构与文件说明

每个软件项目遵循统一的三层结构：

```
<software>/                    # 软件测试项目根目录
├── <software>_test.sh         # 主测试脚本 — 唯一入口，包含构建/验证/基准/报告四阶段 + shUnit2 测试断言
├── scripts/                   # Python 辅助脚本
│   ├── json_helper.py         # JSON 工具 — 10个CLI命令（get/field_exists/throughput_ge/avg_throughput/write_version_info等），shell脚本通过wrapper函数调用
│   ├── benchmark_ann.py       # ANN 搜索基准 — 索引构建+多参数搜索+Recall计算，软件定制
│   ├── micro_benchmark.py     # 微基准 — 索引构建速率/搜索延迟/多线程/序列化等，软件定制
│   ├── aggregate_results.py   # 结果聚合 — 合并 version_info + benchmark_ann + micro_benchmark → results.json
│   └── generate_summary.py    # 文本报告 — results.json → 格式化 results.txt
├── results/                   # 测试产物（按版本隔离）
│   └── <version>/             # 版本子目录（如 0.8.0/、1.14.3/）
│       ├── version_info.json   # 11字段环境信息（test_time/Model/architecture/kernel/os/cpu_model/cpu_cores/software_name/software_version/python_version/numpy_version）
│       ├── benchmark_ann.json  # ANN 基准数据（QPS/Recall/BuildTime/Latency 按 ef 参数扫描）
│       ├── micro_benchmark.json # 微基准数据（构建速率/搜索QPS/多线程缩放/序列化耗时）
│       ├── results.json        # 聚合结果（environment + benchmarks + summary）
│       ├── results.txt         # 可读文本报告
│       └── results.log         # 全流程运行日志
```

**项目目录约束：**
- 仅允许 `<software>_test.sh`、`scripts/`、`results/` 三个条目
- shunit2、构建中间产物、`__pycache__` 等均不留在项目目录（放 `/tmp`）
- 不生成 `results.html`

### 各脚本职责详解

| 文件 | 语言 | 通用/定制 | 职责 |
|---|---|---|---|
| `<software>_test.sh` | Bash | 定制 | 全流程编排：Phase1安装→Phase2版本信息→Phase3基准→Phase4报告，含19+shUnit2测试断言 |
| `json_helper.py` | Python | **通用** | JSON查询/写入CLI工具，10个命令，shell通过`json_throughput_ge`等wrapper调用 |
| `benchmark_ann.py` | Python | 定制 | ANN搜索基准：构建索引→多ef参数搜索→计算Recall→输出benchmark_ann.json |
| `micro_benchmark.py` | Python | 定制 | 微操作基准：索引构建速率、批量搜索、多线程缩放、序列化→输出micro_benchmark.json |
| `aggregate_results.py` | Python | 通用框架 | 加载3个JSON→合并+计算摘要指标→输出results.json |
| `generate_summary.py` | Python | 通用框架 | 读取results.json→生成格式化文本报告results.txt |

---

## 三、性能测试内容与指标分析

### 3.1 测试流程四阶段

| 阶段 | 名称 | 内容 | 产出 |
|---|---|---|---|
| Phase 1 | 安装/构建 | pip安装或git clone源码编译，确保 `import <module>` 可用 | 软件可用 |
| Phase 2 | 版本信息 | 收集11字段环境信息写入 version_info.json | version_info.json |
| Phase 3 | 基准测试 | 运行 ANN 搜索基准 + 微基准 | benchmark_ann.json + micro_benchmark.json |
| Phase 4 | 聚合报告 | 合并数据 + 计算摘要 + 生成文本报告 | results.json + results.txt |

### 3.2 ANN 搜索基准（benchmark_ann）

**测试目的：** 衡量近似最近邻搜索算法在不同精度-速度平衡点的性能表现。

**测试项说明：**

| 测试项 | 含义 | 指标 | 说明 |
|---|---|---|---|
| 索引构建 | 将向量数据加载入索引结构 | Build Time (秒) | 构建耗时越短越好，反映数据入库效率 |
| 索引大小 | 序列化后索引文件体积 | Index Size (字节) | 反映内存占用，M值越大索引越大 |
| 搜索吞吐 | 单位时间处理的查询数 | QPS (queries/sec) | 核心指标，越高越好，直接反映服务能力 |
| 搜索精度 | 找到的真实最近邻比例 | Recall@k (0~1) | 越高越准确，1.0=完美找到所有最近邻 |
| 单查询延迟 | 单次查询平均耗时 | Latency/query (微秒) | 反映用户感知延迟，越低越好 |
| ef 参数扫描 | 在不同 ef_search 值下的 QPS-Recall 曲线 | 多组 (QPS, Recall) | ef 越大→Recall越高但QPS越低，是核心调优参数 |

**关键分析：**
- **QPS vs Recall 权衡曲线** 是 ANN 算法最重要的评估维度。ef_search=10 时 QPS 最高但 Recall 低；ef_search=500 时 Recall 接近1.0但 QPS 下降
- 不同 M 值（16/32/64）影响索引连通性：M 越大→Recall 更高但构建更慢、索引更大、QPS 更低
- **距离度量差异**：L2 最通用，cosine 适合文本，IP 适合内积相似度

**faiss 测试配置：** FlatL2(精确基准线) / IVFFlat / HNSWFlat
**hnswlib 测试配置：** HNSW_L2_M16/M32/M64_ef200 / HNSW_Cosine_M16 / HNSW_IP_M16，ef 扫描 [10, 50, 100, 200, 500]

### 3.3 微基准（micro_benchmark）

**测试目的：** 衡量核心操作的细粒度性能，评估单点效率和多核利用率。

| 测试项 | 含义 | 指标 | 分析要点 |
|---|---|---|---|
| 索引构建速率 | 批量插入向量速度 | add_rate (vectors/sec) | 反映数据入库吞吐，受 M/ef_construction 影响 |
| 增量插入 | 小批量逐次插入 | add_rate (vectors/sec) | 模拟在线增量场景，速率通常低于批量构建 |
| 多线程搜索 | 不同线程数的搜索QPS | QPS × 线程数矩阵 | 理想缩放=线性，实际受内存带宽/锁竞争限制，32核一般5~30x |
| 索引序列化 | save/load 累积时间 | save_time / load_time (秒) | 反映持久化开销，load 通常比 save 快 |
| pickle 序列化 | Python pickle 方式 | pickle_time / unpickle_time (秒) | 比 native save/load 更慢但更通用 |
| ef 参数扫描 | 不同 ef 的搜索质量/速度 | (QPS, Recall) × ef值 | 与 ANN 基准互补，更多 ef 值点（10~1000） |

**多线程缩放比计算：** `scaling_ratio = QPS(threads_all) / QPS(threads_1)`

- 1~2线程通常近2x（线性）
- 4~8线程开始偏离线性
- 全核(32)通常 5~30x，偏离度反映算法的并行瓶颈

### 3.4 shUnit2 测试断言

运行脚本自动执行 19+ 个测试断言，验证全流程正确性：

| 通用断言（所有软件） | 验证内容 |
|---|---|
| testArchitectureIsARM64 | 系统架构为 aarch64 |
| testSoftwareIsInstalled | 软件可 import |
| testSoftwareVersionMatches | 版本号非空 |
| testVersionInfoExists | version_info.json 存在 |
| testVersionInfoHasArchitecture | 含 architecture 字段 |
| testVersionInfoHasSoftwareVersion | 含 software_version 字段 |
| testBenchmark*ProducesResults | 基准 JSON 文件存在 |
| testBenchmark*HasRequiredFields | JSON 含 benchmark/performance_metrics/results_summary |
| testBenchmark*ThroughputAboveThreshold | QPS >= 阈值 |
| testBenchmarkMicroProducesResults | micro_benchmark.json 存在 |
| testBenchmarkMicroAllOperationsCompleted | 操作数 >= 4 |
| testAggregatedResultsExist | results.json 存在 |
| testSummaryReportGenerated | results.txt 存在 |
| testLogFileGenerated | results.log 存在 |
| testAggregatedResultsContainsAllBenchmarks | results.json 包含 ann + micro 数据 |

| 定制断言（按软件） | 验证内容 |
|---|---|
| testBenchmarkANNRecallAboveThreshold | Recall >= 阈值（hnswlib） |
| testBenchmarkANNEfSweepCompleted | ef 扫描数据完整（hnswlib） |
| testBenchmarkMicroIndexConstructionRate | 构建速率 >= 阈值（hnswlib） |
| testBenchmarkMicroMultithreadScaling | 多线程数据存在（hnswlib） |
| testBenchmarkMicroSearchLatencyBelowThreshold | 搜索延迟 <= 阈值（faiss） |

---

## 当前适配软件一览

| 软件 | 版本 | 构建方式 | ANN 配置 | 测试状态 |
|---|---|---|---|---|
| faiss | 1.14.3 | source_build (cmake/make) | FlatL2/IVFFlat/HNSWFlat | 19/19 pass |
| faiss | 1.14.2 | source_build (cmake/make) | FlatL2/IVFFlat/HNSWFlat | 19/19 pass |
| hnswlib | 0.9.0 | source_build (git clone+pip install .) | HNSW L2/Cosine/IP × M16/M32/M64 | 18/19 pass |
| hnswlib | 0.8.0 | pip | HNSW L2/Cosine/IP × M16/M32/M64 | 18/19 pass |
| hnswlib | 0.7.0 | pip | HNSW L2/Cosine/IP × M16/M32/M64 | 18/19 pass |
