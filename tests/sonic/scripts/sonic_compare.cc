#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <chrono>
#include <ctime>
#include <string>
#include <vector>
#include <thread>
#include <sstream>

#include "sonic/sonic.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include "yyjson.h"
#include <nlohmann/json.hpp>

static std::string get_timestamp() {
    auto now = std::chrono::system_clock::now();
    std::time_t t = std::chrono::system_clock::to_time_t(now);
    char buf[64];
    std::strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", std::gmtime(&t));
    return std::string(buf);
}

static std::string make_object_json(int idx) {
    std::ostringstream os;
    os << "{\"id\":" << idx
       << ",\"name\":\"item" << idx << "\","
       << "\"value\":" << (idx * 1.5)
       << ",\"category\":\"cat" << (idx % 8) << "\","
       << "\"tags\":[\"a" << idx << "\",\"b" << idx << "\",\"c" << idx << "\"],"
       << "\"active\":" << ((idx % 2) == 0 ? "true" : "false") << ","
       << "\"score\":" << (idx % 100) << ","
       << "\"desc\":\"a sample description for item number " << idx << "\"}";
    return os.str();
}

static std::string generate_doc() {
    std::string out = "[";
    for (int i = 0; i < 1500; i++) {
        if (i) out += ",";
        out += make_object_json(i);
    }
    out += "]";
    return out;
}

static double now_sec() {
    return std::chrono::duration<double>(
        std::chrono::high_resolution_clock::now().time_since_epoch()).count();
}

struct CompareResult {
    std::string key;
    std::string library;
    std::string operation;
    double qps;
    double avg_time_us;
    double throughput_mbs;
};

static CompareResult bench_sonic_parse(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "sonic_parse"; r.library = "sonic"; r.operation = "parse";
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        sonic_json::Document doc;
        double t0 = now_sec();
        doc.Parse(json);
        double t1 = now_sec();
        total += (t1 - t0);
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_sonic_serialize(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "sonic_serialize"; r.library = "sonic"; r.operation = "serialize";
    sonic_json::Document doc;
    doc.Parse(json);
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        sonic_json::WriteBuffer wb;
        double t0 = now_sec();
        doc.Serialize(wb);
        double t1 = now_sec();
        total += (t1 - t0);
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_rapidjson_parse(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "rapidjson_parse"; r.library = "rapidjson"; r.operation = "parse";
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        rapidjson::Document doc;
        double t0 = now_sec();
        doc.Parse(json.c_str(), json.size());
        double t1 = now_sec();
        total += (t1 - t0);
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_rapidjson_serialize(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "rapidjson_serialize"; r.library = "rapidjson"; r.operation = "serialize";
    rapidjson::Document doc;
    doc.Parse(json.c_str(), json.size());
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        rapidjson::StringBuffer sb;
        rapidjson::Writer<rapidjson::StringBuffer> w(sb);
        double t0 = now_sec();
        doc.Accept(w);
        double t1 = now_sec();
        total += (t1 - t0);
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_yyjson_parse(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "yyjson_parse"; r.library = "yyjson"; r.operation = "parse";
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        double t0 = now_sec();
        yyjson_doc* d = yyjson_read(json.c_str(), json.size(), 0);
        double t1 = now_sec();
        total += (t1 - t0);
        yyjson_doc_free(d);
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_yyjson_serialize(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "yyjson_serialize"; r.library = "yyjson"; r.operation = "serialize";
    yyjson_doc* doc = yyjson_read(json.c_str(), json.size(), 0);
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        size_t written = 0;
        double t0 = now_sec();
        char* out = yyjson_write(doc, 0, &written);
        double t1 = now_sec();
        total += (t1 - t0);
        if (out) free(out);
    }
    yyjson_doc_free(doc);
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_nlohmann_parse(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "nlohmann_parse"; r.library = "nlohmann"; r.operation = "parse";
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        double t0 = now_sec();
        nlohmann::json j = nlohmann::json::parse(json);
        double t1 = now_sec();
        total += (t1 - t0);
        (void)j;
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

static CompareResult bench_nlohmann_serialize(const std::string& json, int iterations) {
    CompareResult r;
    r.key = "nlohmann_serialize"; r.library = "nlohmann"; r.operation = "serialize";
    nlohmann::json j = nlohmann::json::parse(json);
    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        double t0 = now_sec();
        std::string out = j.dump();
        double t1 = now_sec();
        total += (t1 - t0);
        (void)out;
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    return r;
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <mode> <iterations> <output_json> [data_size]\n", argv[0]);
        fprintf(stderr, "  mode: compare\n");
        return 1;
    }

    std::string mode = argv[1];
    int iterations = atoi(argv[2]);
    if (iterations < 1) iterations = 1;
    std::string output_path = argv[3];

    const char* env_version = getenv("SOFTWARE_VERSION");
    std::string version_str = env_version ? env_version : "1.0.2";

    if (mode != "compare") {
        fprintf(stderr, "Unknown mode: %s (expected 'compare')\n", mode.c_str());
        return 1;
    }

    std::string doc = generate_doc();
    std::vector<CompareResult> results;
    results.push_back(bench_sonic_parse(doc, iterations));
    results.push_back(bench_sonic_serialize(doc, iterations));
    results.push_back(bench_rapidjson_parse(doc, iterations));
    results.push_back(bench_rapidjson_serialize(doc, iterations));
    results.push_back(bench_yyjson_parse(doc, iterations));
    results.push_back(bench_yyjson_serialize(doc, iterations));
    results.push_back(bench_nlohmann_parse(doc, iterations));
    results.push_back(bench_nlohmann_serialize(doc, iterations));

    FILE* fp = fopen(output_path.c_str(), "w");
    if (!fp) { fprintf(stderr, "Cannot open %s\n", output_path.c_str()); return 1; }

    fprintf(fp, "{\n");
    fprintf(fp, "  \"benchmark\": \"json_compare\",\n");
    fprintf(fp, "  \"description\": \"sonic vs rapidjson vs yyjson vs nlohmann json head-to-head (parse + serialize) on ARM64\",\n");
    fprintf(fp, "  \"reference\": \"https://github.com/bytedance/sonic-cpp\",\n");
    fprintf(fp, "  \"software\": \"sonic\",\n");
    fprintf(fp, "  \"version\": \"%s\",\n", version_str.c_str());
    fprintf(fp, "  \"architecture\": \"arm64\",\n");
    fprintf(fp, "  \"timestamp\": \"%s\",\n", get_timestamp().c_str());
    fprintf(fp, "  \"performance_metrics\": {\n");
    fprintf(fp, "    \"qps\": {\"unit\": \"ops/s\", \"description\": \"Operations per second\"},\n");
    fprintf(fp, "    \"throughput_mbs\": {\"unit\": \"MB/s\", \"description\": \"JSON bytes processed per second\"}\n");
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"parameters\": {\n");
    fprintf(fp, "    \"doc_size_bytes\": %zu,\n", doc.size());
    fprintf(fp, "    \"iterations\": %d,\n", iterations);
    fprintf(fp, "    \"libraries\": [\"sonic\", \"rapidjson\", \"yyjson\", \"nlohmann\"]\n");
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"results_summary\": {\n");
    for (size_t i = 0; i < results.size(); i++) {
        auto& r = results[i];
        fprintf(fp, "    \"%s\": {\n", r.key.c_str());
        fprintf(fp, "      \"library\": \"%s\",\n", r.library.c_str());
        fprintf(fp, "      \"operation\": \"%s\",\n", r.operation.c_str());
        fprintf(fp, "      \"qps\": %.2f,\n", r.qps);
        fprintf(fp, "      \"avg_time_us\": %.2f,\n", r.avg_time_us);
        fprintf(fp, "      \"throughput_mbs\": %.2f\n", r.throughput_mbs);
        fprintf(fp, "    }%s\n", i < results.size() - 1 ? "," : "");
    }
    fprintf(fp, "  }\n");
    fprintf(fp, "}\n");
    fclose(fp);

    printf("[COMPARE] head-to-head written to %s (%zu entries)\n", output_path.c_str(), results.size());
    return 0;
}
