# Quick reference

- The official hnswlib docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# hnswlib | openEuler
Current hnswlib docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Hnswlib - fast approximate nearest neighbor search. Header-only C++ HNSW implementation with python bindings, insertions and updates.

Hnswlib is lightweight, header-only, and has no dependencies other than C++ 11. It provides interfaces for C++, Python, and external support for Java and R, has full support for incremental index construction and updating the elements, and can work with custom user defined distances (C++).

Learn more about hnswlib on [Hnswlib - fast approximate nearest neighbor search](https://github.com/nmslib/hnswlib).

# Supported tags and respective Dockerfile links
The tag of each `hnswlib` docker image is consist of the version of `hnswlib` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.9.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/hnswlib/0.9.0/24.03-lts-sp4/Dockerfile) | hnswlib 0.9.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/hnswlib` image from docker

	```bash
	docker pull openeuler/hnswlib:{Tag}
	```

- Run an hnswlib C++ program

    Create a file named `hnsw_example.cpp` with the following content:

	```cpp
	#include <hnswlib/hnswlib.h>

	int main() {
	    int dim = 16;
	    int max_elements = 10000;
	    int M = 16;
	    int ef_construction = 200;

	    hnswlib::L2Space space(dim);
	    hnswlib::HierarchicalNSW<float>* alg_hnsw = new hnswlib::HierarchicalNSW<float>(&space, max_elements, M, ef_construction);

	    std::mt19937 rng;
	    rng.seed(47);
	    std::uniform_real_distribution<> distrib_real;
	    float* data = new float[dim * max_elements];
	    for (int i = 0; i < dim * max_elements; i++) {
	        data[i] = distrib_real(rng);
	    }

	    for (int i = 0; i < max_elements; i++) {
	        alg_hnsw->addPoint(data + i * dim, i);
	    }

	    float correct = 0;
	    for (int i = 0; i < max_elements; i++) {
	        std::priority_queue<std::pair<float, hnswlib::labeltype>> result = alg_hnsw->searchKnn(data + i * dim, 1);
	        hnswlib::labeltype label = result.top().second;
	        if (label == i) correct++;
	    }
	    float recall = correct / max_elements;
	    std::cout << "Recall: " << recall << "\n";

	    std::string hnsw_path = "hnsw.bin";
	    alg_hnsw->saveIndex(hnsw_path);
	    delete alg_hnsw;

	    alg_hnsw = new hnswlib::HierarchicalNSW<float>(&space, hnsw_path);
	    correct = 0;
	    for (int i = 0; i < max_elements; i++) {
	        std::priority_queue<std::pair<float, hnswlib::labeltype>> result = alg_hnsw->searchKnn(data + i * dim, 1);
	        hnswlib::labeltype label = result.top().second;
	        if (label == i) correct++;
	    }
	    recall = (float)correct / max_elements;
	    std::cout << "Recall of deserialized index: " << recall << "\n";

	    delete[] data;
	    delete alg_hnsw;
	    return 0;
	}
	```

- Compile the program inside the container

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/hnswlib:{Tag} g++ -std=c++11 -O2 -pthread /workspace/hnsw_example.cpp -o /workspace/hnsw_example
	```

- Run the compiled program

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/hnswlib:{Tag} /workspace/hnsw_example
	```

- Check the container logs

	```bash
	docker run --rm --name hnswlib-test -v $(pwd):/workspace openeuler/hnswlib:{Tag} /workspace/hnsw_example
	docker logs hnswlib-test
	```

- Open an interactive shell

	```bash
	docker run -it --rm -v $(pwd):/workspace openeuler/hnswlib:{Tag} bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
