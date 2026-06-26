#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <chrono>
#include <ctime>
#include <string>
#include <vector>
#include <thread>
#include <snappy.h>

static std::string get_timestamp() {
    auto now = std::chrono::system_clock::now();
    std::time_t t = std::chrono::system_clock::to_time_t(now);
    char buf[64];
    std::strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", std::gmtime(&t));
    return std::string(buf);
}

static std::string generate_random_data(size_t size) {
    std::string data(size, '\0');
    for (size_t i = 0; i < size; i++) {
        data[i] = static_cast<char>('a' + (rand() % 26));
    }
    return data;
}

static std::string generate_repeated_data(size_t size) {
    std::string pattern = "abcdefghij";
    std::string data;
    while (data.size() < size) data += pattern;
    data.resize(size);
    return data;
}

static std::string generate_text_data(size_t size) {
    std::string words[] = {"hello", "world", "test", "benchmark", "snappy",
                           "compress", "decompress", "fast", "data", "arm64",
                           "openeuler", "kunpeng", "performance", "speed", "ratio"};
    std::string data;
    while (data.size() < size) data += words[rand() % 15] + " ";
    data.resize(size);
    return data;
}

static std::string generate_html_data(size_t size) {
    std::string tags[] = {"<div>", "<p>", "<span>", "<a href=\"#\">", "<li>",
                          "<td>", "<tr>", "<th>", "<h1>", "<h2>"};
    std::string data;
    while (data.size() < size) data += tags[rand() % 10] + "content</end> ";
    data.resize(size);
    return data;
}

struct BenchResult {
    std::string data_type;
    size_t original_size;
    size_t compressed_size;
    double compression_ratio;
    double compress_speed_mbs;
    double decompress_speed_mbs;
    double compress_latency_us;
    double decompress_latency_us;
};

static BenchResult run_compression_bench(const std::string& input, int iterations) {
    BenchResult r;
    r.original_size = input.size();
    std::string compressed;
    snappy::Compress(input.data(), input.size(), &compressed);
    r.compressed_size = compressed.size();
    r.compression_ratio = static_cast<double>(input.size()) / static_cast<double>(compressed.size());

    double total_compress_time = 0.0;
    double total_decompress_time = 0.0;
    for (int i = 0; i < iterations; i++) {
        std::string comp_out;
        auto t0 = std::chrono::high_resolution_clock::now();
        snappy::Compress(input.data(), input.size(), &comp_out);
        auto t1 = std::chrono::high_resolution_clock::now();
        total_compress_time += std::chrono::duration<double>(t1 - t0).count();

        std::string decomp_out;
        auto t2 = std::chrono::high_resolution_clock::now();
        snappy::Uncompress(comp_out.data(), comp_out.size(), &decomp_out);
        auto t3 = std::chrono::high_resolution_clock::now();
        total_decompress_time += std::chrono::duration<double>(t3 - t2).count();
    }

    double avg_compress_time = total_compress_time / iterations;
    double avg_decompress_time = total_decompress_time / iterations;
    double input_mb = static_cast<double>(input.size()) / (1024.0 * 1024.0);

    r.compress_speed_mbs = input_mb / avg_compress_time;
    r.decompress_speed_mbs = input_mb / avg_decompress_time;
    r.compress_latency_us = avg_compress_time * 1e6;
    r.decompress_latency_us = avg_decompress_time * 1e6;
    return r;
}

struct MicroBlockResult {
    size_t block_size;
    double compress_speed_mbs;
    double decompress_speed_mbs;
    double compress_latency_us;
    double decompress_latency_us;
    double compression_ratio;
};

static MicroBlockResult run_block_bench(size_t block_size, int iterations) {
    std::string input = generate_text_data(block_size);
    MicroBlockResult r;
    r.block_size = block_size;

    double total_comp = 0.0;
    double total_decomp = 0.0;
    size_t compressed_size = 0;
    for (int i = 0; i < iterations; i++) {
        std::string comp_out;
        auto t0 = std::chrono::high_resolution_clock::now();
        snappy::Compress(input.data(), input.size(), &comp_out);
        auto t1 = std::chrono::high_resolution_clock::now();
        total_comp += std::chrono::duration<double>(t1 - t0).count();
        if (i == 0) compressed_size = comp_out.size();

        std::string decomp_out;
        auto t2 = std::chrono::high_resolution_clock::now();
        snappy::Uncompress(comp_out.data(), comp_out.size(), &decomp_out);
        auto t3 = std::chrono::high_resolution_clock::now();
        total_decomp += std::chrono::duration<double>(t3 - t2).count();
    }

    double mb = static_cast<double>(block_size) / (1024.0 * 1024.0);
    r.compress_speed_mbs = mb / (total_comp / iterations);
    r.decompress_speed_mbs = mb / (total_decomp / iterations);
    r.compress_latency_us = (total_comp / iterations) * 1e6;
    r.decompress_latency_us = (total_decomp / iterations) * 1e6;
    r.compression_ratio = static_cast<double>(block_size) / static_cast<double>(compressed_size);
    return r;
}

struct MtResult {
    int threads;
    double compress_speed_mbs;
    double decompress_speed_mbs;
    double total_compress_time_s;
    double total_decompress_time_s;
};

static MtResult run_mt_bench(size_t block_size, int num_threads, int iterations) {
    MtResult r;
    r.threads = num_threads;
    std::string input = generate_text_data(block_size);

    double total_comp_wall = 0.0;
    double total_decomp_wall = 0.0;

    for (int iter = 0; iter < iterations; iter++) {
        std::vector<std::string> comp_results(num_threads);
        std::vector<std::thread> threads;

        auto c_start = std::chrono::high_resolution_clock::now();
        for (int t = 0; t < num_threads; t++) {
            threads.emplace_back([&, t]() {
                snappy::Compress(input.data(), input.size(), &comp_results[t]);
            });
        }
        for (auto& th : threads) th.join();
        auto c_end = std::chrono::high_resolution_clock::now();
        total_comp_wall += std::chrono::duration<double>(c_end - c_start).count();

        std::vector<std::string> decomp_results(num_threads);
        std::vector<std::thread> d_threads;

        auto d_start = std::chrono::high_resolution_clock::now();
        for (int t = 0; t < num_threads; t++) {
            d_threads.emplace_back([&, t]() {
                snappy::Uncompress(comp_results[t].data(), comp_results[t].size(), &decomp_results[t]);
            });
        }
        for (auto& th : d_threads) th.join();
        auto d_end = std::chrono::high_resolution_clock::now();
        total_decomp_wall += std::chrono::duration<double>(d_end - d_start).count();
    }

    double mb_per_block = static_cast<double>(block_size) / (1024.0 * 1024.0);
    double total_mb = mb_per_block * num_threads * iterations;

    r.compress_speed_mbs = total_mb / total_comp_wall;
    r.decompress_speed_mbs = total_mb / total_decomp_wall;
    r.total_compress_time_s = total_comp_wall / iterations;
    r.total_decompress_time_s = total_decomp_wall / iterations;
    return r;
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <mode> <iterations> <output_json> [data_size]\n", argv[0]);
        fprintf(stderr, "  mode: compression | micro | mt\n");
        return 1;
    }

    std::string mode = argv[1];
    int iterations = atoi(argv[2]);
    std::string output_path = argv[3];
    size_t data_size = 1024 * 1024;
    if (argc >= 5) data_size = atol(argv[4]);

    srand(42);

    if (mode == "compression") {
        std::vector<std::pair<std::string, std::string>> data_types = {
            {"random_data", generate_random_data(data_size)},
            {"repeated_data", generate_repeated_data(data_size)},
            {"text_data", generate_text_data(data_size)},
            {"html_data", generate_html_data(data_size)}
        };

        std::vector<BenchResult> results;
        for (auto& [name, data] : data_types) {
            BenchResult r = run_compression_bench(data, iterations);
            r.data_type = name;
            results.push_back(r);
        }

        FILE* fp = fopen(output_path.c_str(), "w");
        if (!fp) { fprintf(stderr, "Cannot open %s\n", output_path.c_str()); return 1; }

        fprintf(fp, "{\n");
        fprintf(fp, "  \"benchmark\": \"compression\",\n");
        fprintf(fp, "  \"description\": \"Snappy compression/decompression speed across different data patterns on ARM64\",\n");
        fprintf(fp, "  \"reference\": \"https://github.com/google/snappy\",\n");
        fprintf(fp, "  \"software\": \"snappy\",\n");
        fprintf(fp, "  \"version\": \"1.2.2\",\n");
        fprintf(fp, "  \"architecture\": \"arm64\",\n");
        fprintf(fp, "  \"timestamp\": \"%s\",\n", get_timestamp().c_str());
        fprintf(fp, "  \"performance_metrics\": {\n");
        fprintf(fp, "    \"compress_speed_mbs\": {\"unit\": \"MB/s\", \"description\": \"Compression throughput in megabytes per second\"},\n");
        fprintf(fp, "    \"decompress_speed_mbs\": {\"unit\": \"MB/s\", \"description\": \"Decompression throughput in megabytes per second\"},\n");
        fprintf(fp, "    \"compression_ratio\": {\"unit\": \"ratio\", \"description\": \"Original size divided by compressed size\"}\n");
        fprintf(fp, "  },\n");
        fprintf(fp, "  \"parameters\": {\n");
        fprintf(fp, "    \"data_size_bytes\": %zu,\n", data_size);
        fprintf(fp, "    \"iterations\": %d\n", iterations);
        fprintf(fp, "  },\n");
        fprintf(fp, "  \"results_summary\": {\n");
        for (size_t i = 0; i < results.size(); i++) {
            auto& r = results[i];
            fprintf(fp, "    \"%s\": {\n", r.data_type.c_str());
            fprintf(fp, "      \"original_size_bytes\": %zu,\n", r.original_size);
            fprintf(fp, "      \"compressed_size_bytes\": %zu,\n", r.compressed_size);
            fprintf(fp, "      \"compression_ratio\": %.4f,\n", r.compression_ratio);
            fprintf(fp, "      \"compress_speed_mbs\": %.2f,\n", r.compress_speed_mbs);
            fprintf(fp, "      \"decompress_speed_mbs\": %.2f,\n", r.decompress_speed_mbs);
            fprintf(fp, "      \"compress_latency_us\": %.2f,\n", r.compress_latency_us);
            fprintf(fp, "      \"decompress_latency_us\": %.2f\n", r.decompress_latency_us);
            fprintf(fp, "    }%s\n", i < results.size() - 1 ? "," : "");
        }
        fprintf(fp, "  }\n");
        fprintf(fp, "}\n");
        fclose(fp);

    } else if (mode == "micro") {
        std::vector<size_t> block_sizes = {1024, 4096, 16384, 65536, 262144, 1048576};
        std::vector<MicroBlockResult> block_results;
        for (auto bs : block_sizes) {
            block_results.push_back(run_block_bench(bs, iterations));
        }

        int max_threads = static_cast<int>(std::thread::hardware_concurrency());
        if (max_threads == 0) max_threads = 4;
        std::vector<int> thread_counts = {1, 2, 4, 8, max_threads};
        std::vector<MtResult> mt_results;
        for (int tc : thread_counts) {
            mt_results.push_back(run_mt_bench(65536, tc, iterations));
        }

        FILE* fp = fopen(output_path.c_str(), "w");
        if (!fp) { fprintf(stderr, "Cannot open %s\n", output_path.c_str()); return 1; }

        fprintf(fp, "{\n");
        fprintf(fp, "  \"benchmark\": \"micro_operations\",\n");
        fprintf(fp, "  \"description\": \"Snappy micro benchmarks: block-level compress/decompress latency and multithread scaling on ARM64\",\n");
        fprintf(fp, "  \"reference\": \"https://github.com/google/snappy\",\n");
        fprintf(fp, "  \"software\": \"snappy\",\n");
        fprintf(fp, "  \"version\": \"1.2.2\",\n");
        fprintf(fp, "  \"architecture\": \"arm64\",\n");
        fprintf(fp, "  \"timestamp\": \"%s\",\n", get_timestamp().c_str());
        fprintf(fp, "  \"performance_metrics\": {\n");
        fprintf(fp, "    \"compress_speed_mbs\": {\"unit\": \"MB/s\", \"description\": \"Block compression throughput\"},\n");
        fprintf(fp, "    \"decompress_speed_mbs\": {\"unit\": \"MB/s\", \"description\": \"Block decompression throughput\"},\n");
        fprintf(fp, "    \"compress_latency_us\": {\"unit\": \"us\", \"description\": \"Single block compress latency\"},\n");
        fprintf(fp, "    \"decompress_latency_us\": {\"unit\": \"us\", \"description\": \"Single block decompress latency\"}\n");
        fprintf(fp, "  },\n");
        fprintf(fp, "  \"parameters\": {\n");
        fprintf(fp, "    \"block_sizes\": [");
        for (size_t i = 0; i < block_sizes.size(); i++) {
            fprintf(fp, "%zu%s", block_sizes[i], i < block_sizes.size() - 1 ? ", " : "");
        }
        fprintf(fp, "],\n");
        fprintf(fp, "    \"iterations\": %d,\n", iterations);
        fprintf(fp, "    \"max_threads\": %d,\n", max_threads);
        fprintf(fp, "    \"data_size_bytes\": %zu\n", data_size);
        fprintf(fp, "  },\n");
        fprintf(fp, "  \"results\": {\n");

        fprintf(fp, "    \"block_compress_decompress\": {\n");
        for (size_t i = 0; i < block_results.size(); i++) {
            auto& r = block_results[i];
            fprintf(fp, "      \"%zu\": {\n", r.block_size);
            fprintf(fp, "        \"compress_speed_mbs\": %.2f,\n", r.compress_speed_mbs);
            fprintf(fp, "        \"decompress_speed_mbs\": %.2f,\n", r.decompress_speed_mbs);
            fprintf(fp, "        \"compress_latency_us\": %.2f,\n", r.compress_latency_us);
            fprintf(fp, "        \"decompress_latency_us\": %.2f,\n", r.decompress_latency_us);
            fprintf(fp, "        \"compression_ratio\": %.4f\n", r.compression_ratio);
            fprintf(fp, "      }%s\n", i < block_results.size() - 1 ? "," : "");
        }
        fprintf(fp, "    },\n");

        fprintf(fp, "    \"multithread_scaling\": {\n");
        for (size_t i = 0; i < mt_results.size(); i++) {
            auto& r = mt_results[i];
            fprintf(fp, "      \"threads_%d\": {\n", r.threads);
            fprintf(fp, "        \"compress_speed_mbs\": %.2f,\n", r.compress_speed_mbs);
            fprintf(fp, "        \"decompress_speed_mbs\": %.2f,\n", r.decompress_speed_mbs);
            fprintf(fp, "        \"total_compress_time_s\": %.6f,\n", r.total_compress_time_s);
            fprintf(fp, "        \"total_decompress_time_s\": %.6f\n", r.total_decompress_time_s);
            fprintf(fp, "      }%s\n", i < mt_results.size() - 1 ? "," : "");
        }
        fprintf(fp, "    }\n");

        fprintf(fp, "  }\n");
        fprintf(fp, "}\n");
        fclose(fp);

    } else {
        fprintf(stderr, "Unknown mode: %s\n", mode.c_str());
        return 1;
    }

    return 0;
}
