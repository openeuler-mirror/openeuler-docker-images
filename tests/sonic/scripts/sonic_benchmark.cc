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

static std::string generate_small_doc() {
    std::string out = "[";
    for (int i = 0; i < 15; i++) {
        if (i) out += ",";
        out += make_object_json(i);
    }
    out += "]";
    return out;
}

static std::string generate_medium_doc() {
    std::string out = "[";
    for (int i = 0; i < 1500; i++) {
        if (i) out += ",";
        out += make_object_json(i);
    }
    out += "]";
    return out;
}

static std::string generate_large_doc() {
    std::string out = "[";
    for (int i = 0; i < 15000; i++) {
        if (i) out += ",";
        out += make_object_json(i);
    }
    out += "]";
    return out;
}

struct OpResult {
    std::string key;
    std::string operation;
    size_t doc_size_bytes;
    double qps;
    double avg_time_us;
    double throughput_mbs;
};

static double now_sec() {
    return std::chrono::duration<double>(
        std::chrono::high_resolution_clock::now().time_since_epoch()).count();
}

static OpResult bench_parse(const std::string& name, const std::string& json, int iterations) {
    OpResult r;
    r.key = name;
    r.operation = "parse";
    r.doc_size_bytes = json.size();

    double total = 0.0;
    bool ok = false;
    for (int i = 0; i < iterations; i++) {
        sonic_json::Document doc;
        double t0 = now_sec();
        doc.Parse(json);
        double t1 = now_sec();
        total += (t1 - t0);
        ok = !doc.HasParseError();
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    double mb = static_cast<double>(json.size()) / (1024.0 * 1024.0);
    r.throughput_mbs = (avg > 0) ? mb / avg : 0.0;
    (void)ok;
    return r;
}

static OpResult bench_serialize(const std::string& name, const std::string& json, int iterations) {
    OpResult r;
    r.key = name;
    r.operation = "serialize";
    r.doc_size_bytes = json.size();

    sonic_json::Document doc;
    doc.Parse(json);
    if (doc.HasParseError()) {
        r.qps = 0; r.avg_time_us = 0; r.throughput_mbs = 0;
        return r;
    }

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

static OpResult bench_find(const std::string& name, const std::string& json, int iterations) {
    OpResult r;
    r.key = name;
    r.operation = "find";
    r.doc_size_bytes = json.size();

    sonic_json::Document doc;
    doc.Parse(json);

    double total = 0.0;
    for (int i = 0; i < iterations; i++) {
        double t0 = now_sec();
        volatile bool found = false;
        if (doc.IsArray() && doc.Size() > 0) {
            auto& first = doc[0];
            auto it = first.FindMember("name");
            if (it != first.MemberEnd()) found = true;
        }
        double t1 = now_sec();
        total += (t1 - t0);
        (void)found;
    }
    double avg = total / iterations;
    r.avg_time_us = avg * 1e6;
    r.qps = (avg > 0) ? 1.0 / avg : 0.0;
    r.throughput_mbs = 0.0;
    return r;
}

static void write_json_benchmark(const std::string& output_path, const std::vector<OpResult>& results,
                                 const std::string& version_str, int iterations) {
    FILE* fp = fopen(output_path.c_str(), "w");
    if (!fp) { fprintf(stderr, "Cannot open %s\n", output_path.c_str()); return; }

    fprintf(fp, "{\n");
    fprintf(fp, "  \"benchmark\": \"json\",\n");
    fprintf(fp, "  \"description\": \"sonic-cpp JSON parse/serialize/find benchmark across document sizes on ARM64\",\n");
    fprintf(fp, "  \"reference\": \"https://github.com/bytedance/sonic-cpp\",\n");
    fprintf(fp, "  \"software\": \"sonic\",\n");
    fprintf(fp, "  \"version\": \"%s\",\n", version_str.c_str());
    fprintf(fp, "  \"architecture\": \"arm64\",\n");
    fprintf(fp, "  \"timestamp\": \"%s\",\n", get_timestamp().c_str());
    fprintf(fp, "  \"performance_metrics\": {\n");
    fprintf(fp, "    \"qps\": {\"unit\": \"ops/s\", \"description\": \"Operations per second\"},\n");
    fprintf(fp, "    \"throughput_mbs\": {\"unit\": \"MB/s\", \"description\": \"JSON bytes processed per second\"},\n");
    fprintf(fp, "    \"avg_time_us\": {\"unit\": \"us\", \"description\": \"Average time per operation\"}\n");
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"parameters\": {\n");
    fprintf(fp, "    \"iterations\": %d,\n", iterations);
    fprintf(fp, "    \"doc_sizes\": [\"small(~1KB)\", \"medium(~100KB)\", \"large(~1MB)\"]\n");
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"results_summary\": {\n");
    for (size_t i = 0; i < results.size(); i++) {
        auto& r = results[i];
        fprintf(fp, "    \"%s\": {\n", r.key.c_str());
        fprintf(fp, "      \"operation\": \"%s\",\n", r.operation.c_str());
        fprintf(fp, "      \"doc_size_bytes\": %zu,\n", r.doc_size_bytes);
        fprintf(fp, "      \"qps\": %.2f,\n", r.qps);
        fprintf(fp, "      \"avg_time_us\": %.2f,\n", r.avg_time_us);
        fprintf(fp, "      \"throughput_mbs\": %.2f\n", r.throughput_mbs);
        fprintf(fp, "    }%s\n", i < results.size() - 1 ? "," : "");
    }
    fprintf(fp, "  }\n");
    fprintf(fp, "}\n");
    fclose(fp);
}

static void write_micro_benchmark(const std::string& output_path, int iterations,
                                  const std::string& version_str, size_t data_size) {
    std::vector<std::pair<size_t, std::string>> docs = {
        {1024, generate_small_doc()},
        {102400, generate_medium_doc()},
        {1048576, generate_large_doc()}
    };

    struct LatEntry { size_t size; double avg_time_us; double qps; };
    std::vector<LatEntry> lat;
    for (auto& [sz, doc] : docs) {
        sonic_json::Document d;
        d.Parse(doc);
        double total = 0.0;
        for (int i = 0; i < iterations; i++) {
            double t0 = now_sec();
            sonic_json::Document dd;
            dd.Parse(doc);
            double t1 = now_sec();
            total += (t1 - t0);
        }
        LatEntry e;
        e.size = sz;
        e.avg_time_us = (total / iterations) * 1e6;
        e.qps = (total > 0) ? iterations / total : 0.0;
        lat.push_back(e);
    }

    int max_threads = static_cast<int>(std::thread::hardware_concurrency());
    if (max_threads == 0) max_threads = 4;
    std::vector<int> thread_counts = {1, 2, 4, 8, max_threads};
    struct MtEntry { int threads; double qps; double total_time_s; };
    std::vector<MtEntry> mt;
    std::string med_doc = generate_medium_doc();
    for (int tc : thread_counts) {
        double total_wall = 0.0;
        for (int iter = 0; iter < iterations; iter++) {
            auto t_start = std::chrono::high_resolution_clock::now();
            std::vector<std::thread> threads;
            std::vector<int> oks(tc, 0);
            for (int t = 0; t < tc; t++) {
                threads.emplace_back([&, t]() {
                    sonic_json::Document d;
                    d.Parse(med_doc);
                    if (!d.HasParseError()) oks[t] = 1;
                });
            }
            for (auto& th : threads) th.join();
            auto t_end = std::chrono::high_resolution_clock::now();
            total_wall += std::chrono::duration<double>(t_end - t_start).count();
        }
        MtEntry e;
        e.threads = tc;
        e.qps = (total_wall > 0) ? (tc * iterations) / total_wall : 0.0;
        e.total_time_s = total_wall / iterations;
        mt.push_back(e);
    }

    FILE* fp = fopen(output_path.c_str(), "w");
    if (!fp) { fprintf(stderr, "Cannot open %s\n", output_path.c_str()); return; }

    fprintf(fp, "{\n");
    fprintf(fp, "  \"benchmark\": \"micro_operations\",\n");
    fprintf(fp, "  \"description\": \"sonic-cpp micro: per-size parse latency and multithread parse scaling on ARM64\",\n");
    fprintf(fp, "  \"reference\": \"https://github.com/bytedance/sonic-cpp\",\n");
    fprintf(fp, "  \"software\": \"sonic\",\n");
    fprintf(fp, "  \"version\": \"%s\",\n", version_str.c_str());
    fprintf(fp, "  \"architecture\": \"arm64\",\n");
    fprintf(fp, "  \"timestamp\": \"%s\",\n", get_timestamp().c_str());
    fprintf(fp, "  \"performance_metrics\": {\n");
    fprintf(fp, "    \"qps\": {\"unit\": \"ops/s\", \"description\": \"Parses per second\"},\n");
    fprintf(fp, "    \"avg_time_us\": {\"unit\": \"us\", \"description\": \"Single parse latency\"}\n");
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"parameters\": {\n");
    fprintf(fp, "    \"iterations\": %d,\n", iterations);
    fprintf(fp, "    \"max_threads\": %d,\n", max_threads);
    fprintf(fp, "    \"data_size_bytes\": %zu\n", data_size);
    fprintf(fp, "  },\n");
    fprintf(fp, "  \"results\": {\n");
    fprintf(fp, "    \"parse_latency_by_size\": {\n");
    for (size_t i = 0; i < lat.size(); i++) {
        fprintf(fp, "      \"%zu\": {\n", lat[i].size);
        fprintf(fp, "        \"avg_time_us\": %.2f,\n", lat[i].avg_time_us);
        fprintf(fp, "        \"qps\": %.2f\n", lat[i].qps);
        fprintf(fp, "      }%s\n", i < lat.size() - 1 ? "," : "");
    }
    fprintf(fp, "    },\n");
    fprintf(fp, "    \"multithread_parse\": {\n");
    for (size_t i = 0; i < mt.size(); i++) {
        fprintf(fp, "      \"threads_%d\": {\n", mt[i].threads);
        fprintf(fp, "        \"qps\": %.2f,\n", mt[i].qps);
        fprintf(fp, "        \"total_time_s\": %.6f\n", mt[i].total_time_s);
        fprintf(fp, "      }%s\n", i < mt.size() - 1 ? "," : "");
    }
    fprintf(fp, "    }\n");
    fprintf(fp, "  }\n");
    fprintf(fp, "}\n");
    fclose(fp);
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <mode> <iterations> <output_json> [data_size]\n", argv[0]);
        fprintf(stderr, "  mode: json | micro\n");
        return 1;
    }

    std::string mode = argv[1];
    int iterations = atoi(argv[2]);
    if (iterations < 1) iterations = 1;
    std::string output_path = argv[3];
    size_t data_size = 1048576;
    if (argc >= 5) data_size = atol(argv[4]);

    const char* env_version = getenv("SOFTWARE_VERSION");
    std::string version_str = env_version ? env_version : "1.0.2";

    if (mode == "json") {
        std::string small = generate_small_doc();
        std::string medium = generate_medium_doc();
        std::string large = generate_large_doc();
        (void)data_size;

        std::vector<OpResult> results;
        results.push_back(bench_parse("parse_small", small, iterations));
        results.push_back(bench_parse("parse_medium", medium, iterations));
        results.push_back(bench_parse("parse_large", large, iterations));
        results.push_back(bench_serialize("serialize_small", small, iterations));
        results.push_back(bench_serialize("serialize_medium", medium, iterations));
        results.push_back(bench_serialize("serialize_large", large, iterations));
        results.push_back(bench_find("find_medium", medium, iterations));

        write_json_benchmark(output_path, results, version_str, iterations);
        printf("[BENCH] json benchmark written to %s (%zu entries)\n", output_path.c_str(), results.size());

    } else if (mode == "micro") {
        write_micro_benchmark(output_path, iterations, version_str, data_size);
        printf("[BENCH] micro benchmark written to %s\n", output_path.c_str());

    } else {
        fprintf(stderr, "Unknown mode: %s\n", mode.c_str());
        return 1;
    }
    return 0;
}
