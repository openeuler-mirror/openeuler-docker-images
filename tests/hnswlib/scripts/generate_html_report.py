#!/usr/bin/env python3
import json
import os
import argparse
import datetime

CSS = """
<style>
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; background: #f5f5f5; }
.header { background: linear-gradient(135deg, #2c3e50, #27ae60); color: white; padding: 30px; border-radius: 8px; margin-bottom: 20px; }
.header h1 { margin: 0; font-size: 28px; }
.header .meta { font-size: 14px; color: #ecf0f1; margin-top: 8px; }
.section { background: white; padding: 20px; border-radius: 8px; margin-bottom: 15px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.section h2 { color: #2c3e50; border-bottom: 2px solid #27ae60; padding-bottom: 8px; margin-top: 0; }
.section h3 { color: #34495e; margin-top: 15px; }
table { width: 100%; border-collapse: collapse; margin: 10px 0; }
th { background: #27ae60; color: white; padding: 10px; text-align: left; }
td { padding: 8px 10px; border-bottom: 1px solid #ecf0f1; }
tr:hover { background: #f0f8ff; }
.metric-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 12px; margin: 15px 0; }
.metric-card { background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 15px; text-align: center; }
.metric-card .label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
.metric-card .value { font-size: 24px; font-weight: bold; color: #2c3e50; margin-top: 5px; }
.metric-card .unit { font-size: 11px; color: #95a5a6; }
.metric-card.pass .value { color: #4CAF50; }
.metric-card.fail .value { color: #f44336; }
.arm64-badge { background: #27ae60; color: white; padding: 2px 8px; border-radius: 3px; font-size: 12px; font-weight: bold; }
.bar-chart { margin: 15px 0; }
.bar-row { display: flex; align-items: center; margin: 6px 0; }
.bar-label { width: 180px; font-size: 13px; text-align: right; padding-right: 10px; }
.bar-container { flex: 1; background: #ecf0f1; border-radius: 4px; height: 22px; position: relative; }
.bar-fill { height: 100%; border-radius: 4px; transition: width 0.3s; }
.bar-value { font-size: 12px; color: #2c3e50; margin-left: 8px; white-space: nowrap; }
.shunit2-section { background: #e8f5e9; padding: 16px; border-radius: 6px; margin-top: 16px; }
.shunit2-section h2 { color: #2e7d32; }
</style>
"""


def make_bar_chart(title, items, max_val=None, color="#27ae60"):
    if max_val is None:
        max_val = max(v for _, v in items) if items else 1
    if max_val == 0:
        max_val = 1
    html = f'<h3>{title}</h3><div class="bar-chart">'
    for label, value in items:
        pct = (value / max_val * 100) if max_val > 0 else 0
        html += f'''<div class="bar-row">
            <div class="bar-label">{label}</div>
            <div class="bar-container"><div class="bar-fill" style="width:{pct:.1f}%;background:{color}"></div></div>
            <div class="bar-value">{value:.2f}</div>
        </div>'''
    html += '</div>'
    return html


def main():
    parser = argparse.ArgumentParser(description='Generate HTML report for hnswlib ARM64 benchmark results')
    parser.add_argument('--input', required=True, help='Input results.json file')
    parser.add_argument('--output', required=True, help='Output results.html file')
    args = parser.parse_args()

    if not os.path.exists(args.input):
        print('[HTML] results.json not found')
        return

    with open(args.input, 'r') as f:
        data = json.load(f)

    env = data.get('environment', {})
    ann = data.get('benchmarks', {}).get('ann', {})
    micro = data.get('benchmarks', {}).get('micro', {})
    summary = data.get('summary', {})
    timestamp = data.get('timestamp', '')

    vi = env

    html = f'''<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>hnswlib ARM64 Performance Benchmark Report</title>{CSS}</head><body>

<div class="header">
    <h1>hnswlib ARM64 Performance Benchmark Report <span class="arm64-badge">ARM64</span></h1>
    <div class="meta">hnswlib {vi.get("hnswlib_version", vi.get("software_version", "N/A"))} | {vi.get("architecture", "N/A")} | Python {vi.get("runtime_version", "N/A")} | Generated {timestamp}</div>
</div>

<div class="section">
<h2>Environment Information</h2>
<table>
<tr><th>Property</th><th>Value</th></tr>
<tr><td>Architecture</td><td>{vi.get("architecture", "N/A")}</td></tr>
<tr><td>OS</td><td>{vi.get("os", "N/A")}</td></tr>
<tr><td>Kernel</td><td>{vi.get("kernel", "N/A")}</td></tr>
<tr><td>CPU</td><td>{vi.get("cpu_model", "N/A")} ({vi.get("cores", "N/A")} cores)</td></tr>
<tr><td>Memory</td><td>{vi.get("memory_mb", "N/A")} MB</td></tr>
<tr><td>hnswlib Version</td><td>{vi.get("hnswlib_version", vi.get("software_version", "N/A"))}</td></tr>
<tr><td>Python Version</td><td>{vi.get("runtime_version", "N/A")}</td></tr>
<tr><td>NumPy Version</td><td>{vi.get("numpy_version", "N/A")}</td></tr>
<tr><td>Install Method</td><td>{vi.get("install_method", "N/A")} (pip)</td></tr>
<tr><td>NEON/ASIMD</td><td>{vi.get("neon_asimd_available", "N/A")}</td></tr>
<tr><td>Index Defaults</td><td>M={vi.get("index_M", "N/A")}, ef_construction={vi.get("index_ef_construction", "N/A")}</td></tr>
</table>
</div>
'''

    if summary:
        html += '<div class="metric-grid">'
        if 'avg_qps_ef50' in summary:
            html += f'''<div class="metric-card"><div class="label">Avg QPS (ef=50)</div><div class="value">{summary["avg_qps_ef50"]}</div><div class="unit">queries/sec</div></div>'''
        if 'avg_recall_ef200' in summary:
            html += f'''<div class="metric-card"><div class="label">Avg Recall (ef=200)</div><div class="value">{summary["avg_recall_ef200"]}</div><div class="unit">ratio (0-1)</div></div>'''
        if 'avg_latency_us_ef50' in summary:
            html += f'''<div class="metric-card"><div class="label">Avg Latency (ef=50)</div><div class="value">{summary["avg_latency_us_ef50"]}</div><div class="unit">microseconds</div></div>'''
        if 'avg_index_construction_rate' in summary:
            html += f'''<div class="metric-card"><div class="label">Index Construction</div><div class="value">{summary["avg_index_construction_rate"]}</div><div class="unit">vectors/sec</div></div>'''
        if 'multithread_scaling_ratio' in summary:
            html += f'''<div class="metric-card"><div class="label">MT Scaling</div><div class="value">{summary["multithread_scaling_ratio"]}x</div><div class="unit">all vs 1 thread</div></div>'''
        html += '</div>'

    if ann:
        results = ann.get('results_summary', {})
        params = ann.get('parameters', {})
        k_val = params.get('k', 10)
        ef_values = params.get('ef_search_values', [10, 50, 100, 200, 500])

        html += '<div class="section"><h2>ANN Search Benchmark (Phase 3a)</h2>'
        html += f'<p><strong>Reference:</strong> <a href="{ann.get("reference", "")}">{ann.get("reference", "N/A")}</a></p>'
        html += f'<p>Dataset: {params.get("num_vectors", "N/A")} vectors, {params.get("dimension", "N/A")} dims, k={k_val}</p>'

        build_items = []
        for name, res in results.items():
            if "error" not in res:
                build_items.append((name, res.get('avg_build_time_s', 0)))
        if build_items:
            html += make_bar_chart('Build Time (seconds)', build_items, color="#e67e22")

        for ef in ef_values:
            qps_items = []
            for name, res in results.items():
                if "error" not in res:
                    ef_sweep = res.get('avg_ef_sweep', {})
                    ef_data = ef_sweep.get(ef, {})
                    qps_items.append((name, ef_data.get('qps', 0)))
            if qps_items:
                html += make_bar_chart(f'QPS at ef_search={ef}', qps_items, color="#3498db")

        recall_items_best = []
        for name, res in results.items():
            if "error" not in res:
                ef_sweep = res.get('avg_ef_sweep', {})
                max_ef = max(ef_sweep.keys()) if ef_sweep else 0
                best_recall = ef_sweep.get(max_ef, {}).get(f'recall_at_{k_val}', 0) * 100
                recall_items_best.append((name, best_recall))
        if recall_items_best:
            html += make_bar_chart(f'Best Recall@{k_val} (%) at max ef_search', recall_items_best, max_val=100, color="#27ae60")

        html += '<h3>ef_search vs Recall/QPS Trade-off</h3>'
        html += '<table><tr><th>Config</th><th>ef_search</th><th>QPS</th><th>Recall@' + str(k_val) + '</th><th>Latency (us)</th></tr>'
        for name, res in results.items():
            if "error" in res:
                html += f'<tr><td>{name}</td><td colspan="4" style="color:#f44336">ERROR: {res["error"]}</td></tr>'
            else:
                ef_sweep = res.get('avg_ef_sweep', {})
                for ef, ef_res in sorted(ef_sweep.items()):
                    recall_key = f'recall_at_{k_val}'
                    html += f'<tr><td>{name}</td><td>{ef}</td><td>{ef_res.get("qps", "N/A")}</td>'
                    html += f'<td>{ef_res.get(recall_key, "N/A")}</td><td>{ef_res.get("latency_per_query_us", "N/A")}</td></tr>'
        html += '</table>'

        html += '<h3>Index Summary</h3><table>'
        html += '<tr><th>Config</th><th>Build Time (s)</th><th>Index Size (bytes)</th><th>Best Recall</th><th>Best QPS</th></tr>'
        for name, res in results.items():
            if "error" in res:
                html += f'<tr><td>{name}</td><td style="color:#f44336">ERROR</td><td colspan="3">{res["error"]}</td></tr>'
            else:
                ef_sweep = res.get('avg_ef_sweep', {})
                best_ef = max(ef_sweep.keys()) if ef_sweep else 0
                best_recall = ef_sweep.get(best_ef, {}).get(f'recall_at_{k_val}', 'N/A')
                best_qps_entry = max(ef_sweep.values(), key=lambda x: x.get('qps', 0)) if ef_sweep else {}
                html += f'<tr><td>{name}</td><td>{res.get("avg_build_time_s", "N/A")}</td>'
                html += f'<td>{res.get("avg_index_size_bytes", "N/A")}</td>'
                html += f'<td>{best_recall}</td><td>{best_qps_entry.get("qps", "N/A")}</td></tr>'
        html += '</table></div>'

    if micro:
        mresults = micro.get('results', {})
        mparams = micro.get('parameters', {})

        html += '<div class="section"><h2>Micro Benchmarks (Phase 3c)</h2>'
        html += f'<p><strong>Reference:</strong> <a href="{micro.get("reference", "")}">{micro.get("reference", "N/A")}</a></p>'
        html += f'<p>Dataset: {mparams.get("num_vectors", "N/A")} vectors, {mparams.get("dimension", "N/A")} dims</p>'

        html += '<div class="metric-grid">'
        ic = mresults.get('index_construction', {})
        if ic:
            html += f'''<div class="metric-card"><div class="label">Index Construction</div><div class="value">{ic.get("add_rate_per_sec", 0)}</div><div class="unit">vectors/sec</div></div>'''
        ii = mresults.get('incremental_insert', {})
        if ii:
            html += f'''<div class="metric-card"><div class="label">Incremental Insert</div><div class="value">{ii.get("add_rate_per_sec", 0)}</div><div class="unit">vectors/sec</div></div>'''
        sl = mresults.get('serialization_save_load', {})
        if sl:
            html += f'''<div class="metric-card"><div class="label">Save Time</div><div class="value">{sl.get("avg_save_time_s", 0)}</div><div class="unit">seconds</div></div>'''
            html += f'''<div class="metric-card"><div class="label">Load Time</div><div class="value">{sl.get("avg_load_time_s", 0)}</div><div class="unit">seconds</div></div>'''
        html += '</div>'

        mt = mresults.get('batch_search_multithread', {})
        if mt:
            mt_items = []
            for thread_label, mt_res in mt.items():
                mt_items.append((thread_label, mt_res.get('avg_qps', 0)))
            if mt_items:
                html += make_bar_chart('Multi-threaded Search QPS', mt_items, color="#3498db")

        sweep = mresults.get('ef_parameter_sweep', {})
        if sweep:
            sweep_recall_items = []
            for ef_label, sweep_res in sweep.items():
                sweep_recall_items.append((ef_label, sweep_res.get('avg_recall', 0) * 100))
            if sweep_recall_items:
                html += make_bar_chart('ef Parameter Sweep: Recall (%)', sweep_recall_items, max_val=100, color="#27ae60")

            sweep_qps_items = []
            for ef_label, sweep_res in sweep.items():
                sweep_qps_items.append((ef_label, sweep_res.get('avg_qps', 0)))
            if sweep_qps_items:
                html += make_bar_chart('ef Parameter Sweep: QPS', sweep_qps_items, color="#3498db")

        html += '<h3>Detailed Results</h3><table><tr><th>Operation</th><th>Key Metrics</th></tr>'
        for op_name, res in mresults.items():
            if isinstance(res, dict) and not any(isinstance(v, dict) for v in res.values()):
                metrics_str = ', '.join(f'{k}={v}' for k, v in res.items() if isinstance(v, (int, float, str)))
                html += f'<tr><td>{op_name}</td><td>{metrics_str}</td></tr>'
            else:
                html += f'<tr><td>{op_name}</td><td>{json.dumps(res)}</td></tr>'
        html += '</table></div>'

    neon_status = "Available" if str(vi.get("neon_asimd_available", "0")) != "0" else "Not detected"
    m_val = vi.get("index_M", 16)
    ef_val = vi.get("index_ef_construction", 200)

    html += f'''
<div class="section">
<h2>ARM64 Optimization Highlights</h2>
<table>
<tr><th>Feature</th><th>Impact</th><th>Status</th></tr>
<tr><td>ARM64 NEON/ASIMD</td><td>Vector ops for distance computation</td><td>{neon_status}</td></tr>
<tr><td>hnswlib pip install</td><td>ARM64 wheel where available</td><td>{vi.get("hnswlib_version", vi.get("software_version", "N/A"))}</td></tr>
<tr><td>NumPy ARM64 native</td><td>Native BLAS/LAPACK on arm64</td><td>{vi.get("numpy_version", "N/A")}</td></tr>
<tr><td>HNSW algorithm</td><td>Graph-based ANN with hierarchical navigable small world</td><td>M={m_val}, ef_construction={ef_val}</td></tr>
</table></div>

<div class="shunit2-section">
<h2>shUnit2 Test Results</h2>
<p>Validation tests via shUnit2. See <code>hnswlib_test.sh</code> for test functions covering all phases.</p>
<table>
<tr><th>Phase</th><th>Test Functions</th><th>Count</th></tr>
<tr><td>Phase 2: Verify</td><td>testArchitectureIsARM64, testPython3Available, testSoftwareIsInstalled, testSoftwareVersionMatches, testVersionInfoJsonExists</td><td>5</td></tr>
<tr><td>Phase 3a: ANN</td><td>testBenchmarkANNProducesResults, testBenchmarkANNHasRequiredFields, testBenchmarkANNThroughputAboveThreshold, testBenchmarkANNRecallAboveThreshold, testBenchmarkANNEfSweepCompleted</td><td>5</td></tr>
<tr><td>Phase 3c: Micro</td><td>testBenchmarkMicroProducesResults, testBenchmarkMicroAllOperationsCompleted, testBenchmarkMicroIndexConstructionRate, testBenchmarkMicroMultithreadScaling</td><td>4</td></tr>
<tr><td>Phase 4: Results</td><td>testAggregatedResultsExist, testHtmlReportGenerated, testSummaryReportGenerated, testLogFileGenerated, testAggregatedResultsContainsAllBenchmarks</td><td>5</td></tr>
</table>
<p><strong>Total: 19 test* functions</strong></p>
</div>
</body></html>'''

    with open(args.output, 'w') as f:
        f.write(html)
    print(f'[HTML] Report saved to {args.output}')


if __name__ == '__main__':
    main()
