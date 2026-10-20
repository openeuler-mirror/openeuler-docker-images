# Quick reference

- The official RocksDB docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# RocksDB | openEuler
Current RocksDB docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

RocksDB is a high performance embedded key-value store for fast storage, developed by Meta. It is a persistent key-value store for fast storage environments based on a Log-Structured Merge Tree, and is widely used as the storage engine behind databases such as Kvrocks, TiDB and MyRocks.

Learn more on [RocksDB](http://rocksdb.org/).

# Supported tags and respective Dockerfile links
The tag of each `rocksdb` docker image is consist of the version of `rocksdb` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.8.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Database/rocksdb/11.8.1/24.03-lts-sp4/Dockerfile) | rocksdb 11.8.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/rocksdb` image from docker

	```bash
	docker pull openeuler/rocksdb:{Tag}
	```

- Compile a program against the installed RocksDB library

	Create a file named `rocksdb_example.cpp` with the following content:

	```cpp
	#include <cassert>
	#include <string>
	#include <rocksdb/db.h>

	int main() {
	    rocksdb::DB* db;
	    rocksdb::Options options;
	    options.create_if_missing = true;
	    rocksdb::Status status = rocksdb::DB::Open(options, "/tmp/testdb", &db);
	    assert(status.ok());

	    const std::string key = "hello";
	    const std::string value = "openEuler";
	    status = db->Put(rocksdb::WriteOptions(), key, value);
	    assert(status.ok());

	    std::string result;
	    status = db->Get(rocksdb::ReadOptions(), key, &result);
	    assert(status.ok() && result == value);

	    delete db;
	    return 0;
	}
	```

	Then compile and run it inside the container:

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/rocksdb:{Tag} \
	    g++ -std=c++17 -O2 /workspace/rocksdb_example.cpp -o /workspace/rocksdb_example \
	    -I/usr/local/include -L/usr/local/lib -lrocksdb -lsnappy -lzstd -lz -lpthread
	```

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/rocksdb:{Tag} /workspace/rocksdb_example
	```

- Run the bundled `db_bench` benchmark

	```bash
	docker run --rm openeuler/rocksdb:{Tag} db_bench --benchmarks=fillseq,readrandom --num=100000
	```

- View container logs

	```bash
	docker logs -f my-rocksdb
	```

- Open an interactive shell

	```bash
	docker run -it --rm openeuler/rocksdb:{Tag} bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
