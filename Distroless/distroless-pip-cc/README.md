# Quick reference

- The official distroless-pip-cc docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-pip-cc | openEuler
This image provides a minimal python pip runtime with libstdc++ support.

Key Components:
 - Python pip runtime
 - libstdc++ (GLIBC implementation)

Use Cases:
 - Python apps with C/C++ extensions (e.g. NumPy/Pandas)
 - Python apps calling C/C++ shared libraries

# Supported tags and respective Dockerfile links
The tag details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[23.3.1-cc12.3.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-pip/23.3.1-cc12.3.1/24.03-lts/Distrofile)| PIP 23.3.1 and libstdc++ 12.3.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
**Dockerfile Example (Python pip with libstdc++ Dependencies)**
```
# Base image with minimal Python pip runtime and libstdc++
FROM openeuler/distroless-pip-cc:23.3.1-cc12.3.1-oe2403lts

# Update CA certificates for SSL verification
RUN update-ca-trust

# Install Python packages with libstdc++ dependencies, pyarrow requires libstdc++ runtime
RUN pip install pyarrow pandas

COPY app.py /app/

CMD ["python3", "/app/app.py"]
```

**app.py (PyArrow Data Processing Example)**
```
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd
from datetime import datetime

def process_data():
    """Demonstrates PyArrow's core features with Arrow Tables and Parquet I/O"""
    
    data = {
        "timestamp": [datetime(2023, 1, 1), datetime(2023, 1, 2)],
        "temperature": [22.5, 23.1],
        "sensor_id": ["A001", "A002"]
    }
    table = pa.Table.from_pydict(data)
    
    df = table.to_pandas()
    print("Pandas DataFrame:")
    print(df)
    
    pq.write_table(table, "/app/data.parquet", compression='SNAPPY')
    reloaded = pq.read_table("/app/data.parquet")
    
    mean_temp = pa.compute.mean(reloaded["temperature"])
    print(f"\nMean temperature: {mean_temp.as_py():.2f}°C")

if __name__ == "__main__":
    print(f"PyArrow version: {pa.__version__}")
    print(f"Running with {pa.cpu_count()} CPU cores")
    process_data()
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).