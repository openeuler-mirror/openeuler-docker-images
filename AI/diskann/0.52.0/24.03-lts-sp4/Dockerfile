ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG RUST_VERSION=1.92.0
ARG VERSION=0.52.0

RUN dnf install -y curl git gcc gcc-c++ make cmake openssl-devel && \
    dnf clean all

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_VERSION}
ENV PATH=/root/.cargo/bin:$PATH

RUN git clone -b v${VERSION} --depth 1 https://github.com/microsoft/DiskANN.git /build
WORKDIR /build

RUN cargo build --release --workspace

FROM ${BASE}

COPY --from=builder /build/target/release/diskann-benchmark /usr/local/bin/
COPY --from=builder /build/target/release/compute_groundtruth /usr/local/bin/
COPY --from=builder /build/target/release/compute_multivec_groundtruth /usr/local/bin/
COPY --from=builder /build/target/release/gen_associated_data_from_range /usr/local/bin/
COPY --from=builder /build/target/release/generate_minmax /usr/local/bin/
COPY --from=builder /build/target/release/generate_pq /usr/local/bin/
COPY --from=builder /build/target/release/generate_synthetic_labels /usr/local/bin/
COPY --from=builder /build/target/release/random_data_generator /usr/local/bin/
COPY --from=builder /build/target/release/relative_contrast /usr/local/bin/
COPY --from=builder /build/target/release/subsample_bin /usr/local/bin/

CMD ["diskann-benchmark", "--help"]
