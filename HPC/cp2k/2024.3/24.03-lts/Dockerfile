ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE} AS build

ARG VERSION=2024.3

RUN yum update -y && \
    yum install -y gcc g++ gfortran openssh-clients bzip2 \
        ca-certificates git make patch pkgconfig unzip wget zlib-devel

RUN if [ "$VERSION" = "2024.3" ]; then \
        git clone -b master --recursive https://github.com/cp2k/cp2k.git /opt/cp2k; \
    else \
        git clone -b support/v${VERSION} --recursive https://github.com/cp2k/cp2k.git /opt/cp2k; \
    fi 

WORKDIR /opt/cp2k/tools/toolchain
RUN /bin/bash -c -o pipefail \
    "./install_cp2k_toolchain.sh -j "$(nproc)" \
     --install-all \
     --enable-cuda=no --with-deepmd=no \
     --target-cpu=generic \
     --with-cusolvermp=no \
     --with-libtorch=no \
     --with-gcc=system \
     --with-openmpi=install"

WORKDIR /opt/cp2k
RUN /bin/bash -c -o pipefail \
    "cp ./tools/toolchain/install/arch/local.psmp ./arch/; \
     source ./tools/toolchain/install/setup; \
     make -j "$(nproc)" ARCH=local VERSION=psmp"

RUN /bin/bash -c -o pipefail \
    "mkdir -p /toolchain/install /toolchain/scripts; \
     for libdir in \$(ldd ./exe/local/cp2k.psmp | \
                      grep /opt/cp2k/tools/toolchain/install | \
                      awk '{print \$3}' | cut -d/ -f7 | \
                      sort | uniq) setup; do \
        cp -ar /opt/cp2k/tools/toolchain/install/\${libdir} /toolchain/install; \
     done; \
     cp /opt/cp2k/tools/toolchain/scripts/tool_kit.sh /toolchain/scripts; \
     unlink ./exe/local/cp2k.popt; \
     unlink ./exe/local/cp2k_shell.psmp"

FROM ${BASE}
RUN yum install -y gcc g++ gfortran openssh-clients && \
    yum clean all
COPY --from=build /opt/cp2k/exe/local/ /opt/cp2k/exe/local/
COPY --from=build /opt/cp2k/tests/ /opt/cp2k/tests/
COPY --from=build /opt/cp2k/tools/regtesting/ /opt/cp2k/tools/regtesting/
COPY --from=build /opt/cp2k/src/grid/sample_tasks/ /opt/cp2k/src/grid/sample_tasks/
COPY --from=build /opt/cp2k/data/ /opt/cp2k/data/
COPY --from=build /toolchain/ /opt/cp2k/tools/toolchain/

RUN /bin/bash -c -o pipefail \
    "for binary in cp2k dumpdcd graph xyz2dcd; do \
        ln -sf /opt/cp2k/exe/local/\${binary}.psmp \
               /usr/local/bin/\${binary}; \
     done; \
     ln -sf /opt/cp2k/exe/local/cp2k.psmp \
            /usr/local/bin/cp2k_shell; \
     ln -sf /opt/cp2k/exe/local/cp2k.psmp \
            /usr/local/bin/cp2k.popt"

# generate entrypoint.sh
RUN printf "#!/bin/bash\n\
ulimit -c 0 -s unlimited\n\
\
export OMPI_ALLOW_RUN_AS_ROOT=1\n\
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1\n\
export OMPI_MCA_btl_vader_single_copy_mechanism=none\n\
export OMP_STACKSIZE=16M\n\
export PATH=/opt/cp2k/exe/local:\${PATH}\n\
source /opt/cp2k/tools/toolchain/install/setup\n\
\"\$@\"" \
>/usr/local/bin/entrypoint.sh && chmod 755 /usr/local/bin/entrypoint.sh

# Create shortcut for regression test
RUN printf "/opt/cp2k/tests/do_regtest.py --mpiexec \"mpiexec --bind-to none\" --maxtasks 8 --workbasedir /mnt \$* local psmp" \
>/usr/local/bin/run_tests && chmod 755 /usr/local/bin/run_tests

# Define entrypoint
WORKDIR /mnt
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["cp2k", "--help"]