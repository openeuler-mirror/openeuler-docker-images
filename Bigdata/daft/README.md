# Quick reference

- The official daft docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# daft | openEuler
Daft is a high-performance distributed query engine for large-scale data processing using Python or SQL, implemented in Rust. It is designed from the ground up to handle both traditional structured data and multimodal data (images, audio, video, embeddings) in a single unified framework. Daft provides a Python-native DataFrame API backed by a Rust-powered vectorized execution engine with SIMD acceleration, high-performance async I/O, cost-based query optimization, and native integration with Ray for distributed scaling across CPU/GPU clusters. Built on Apache Arrow, Daft supports universal connectivity to S3, GCS, Iceberg, Delta Lake, Hugging Face, Unity Catalog, and more.


# Supported tags and respective Dockerfile links
The tag of each daft docker image is consist of the version of daft and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.7.11-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/daft/0.7.11/24.03-lts-sp3/Dockerfile) | daft 0.7.11 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage

Pull the image and start an interactive container:

```bash
docker pull openeuler/daft:0.7.11-oe2403sp3
docker run -it --name daft-container openeuler/daft:0.7.11-oe2403sp3
```

daft is pre-installed in the image. Inside the container, you can use it directly with python3:

```python
import daft

# Read parquet files lazily
df = daft.read_parquet("/path/to/data/*.parquet")

# Apply transformations
df = df.where(df["column_name"] > 100)
df = df.with_column("new_col", df["existing_col"] * 2)

# Display the query plan
df.explain(show_all=True)

# Materialize results
result = df.collect()
result.show(10)
```

You can also run a Python script directly:

```bash
docker run --rm -v $(pwd):/workspace openeuler/daft:0.7.11-oe2403sp3 python3 /workspace/your_script.py
```

Example script:

```python
import daft

# Read parquet files lazily
df = daft.read_parquet("/path/to/data/*.parquet")

# Apply transformations
df = df.where(df["column_name"] > 100)
df = df.with_column("new_col", df["existing_col"] * 2)

# Display the query plan
df.explain(show_all=True)

# Materialize results
result = df.collect()
result.show(10)
```

To process multimodal data (images, audio, video) at scale:

```python
import daft

# Load image file paths from S3
df = daft.from_glob_path("s3://bucket/images/*")

# Download and decode images
df = df.with_column("image", df["path"].url.download().image.decode())

# Resize and classify images
df = df.with_column("resized", df["image"].image.resize(32, 32))
df.show(3)
```

For more details, refer to the [Daft Quickstart Guide](https://www.getdaft.io/projects/docs/en/latest/learn/10-min.html).

Learn more on [Daft: High-Performance Data Engine for AI and Multimodal Workloads](https://www.daft.ai).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).