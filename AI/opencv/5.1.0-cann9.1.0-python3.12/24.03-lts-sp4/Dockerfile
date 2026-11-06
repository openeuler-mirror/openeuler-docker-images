# syntax=docker/dockerfile:1
# OpenCV built from source with the Huawei Ascend CANN backend (WITH_CANN=ON).
FROM quay.io/ascend/cann:9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=5.1.0

LABEL author="openEuler CloudNative SIG" description="OpenCV built from source with the Ascend CANN backend (dnn NPU backend + cannops)"

# Build dependencies
RUN dnf install -y git gcc gcc-c++ make cmake pkgconf \
        libjpeg-turbo-devel libpng-devel libtiff-devel && \
    dnf clean all

# Clone OpenCV and opencv_contrib at the same release tag
RUN git clone --depth 1 --branch ${VERSION} https://github.com/opencv/opencv.git /tmp/opencv && \
    git clone --depth 1 --branch ${VERSION} https://github.com/opencv/opencv_contrib.git /tmp/opencv_contrib

# Apply the CANN source patches that make OpenCV 5.x compile and link against
# CANN 9.1.0 (same patches as projects/opencv/scripts/patch_opencv_cann.py in
# the workflows repository):
#   (a-d) cv::MatShape type changes in the dnn CANN backend,
#   (e-f) narrow CANN op headers per dnn translation unit (aarch64 +/-128 MiB
#         relocation window),
#   (g)   NULL-stream fallback for CANN 9.x (EH0008).
# Each patch is idempotent and fails loudly when an anchor is missing.
WORKDIR /tmp
RUN python3 - <<'PY'
import pathlib


def patch(rel, old, new, *, expect_present=True, count=1):
    p = pathlib.Path(rel)
    if not p.exists():
        if expect_present:
            print(f'(skip) {rel}: file not present')
        return
    s = p.read_text()
    if new in s:
        print(f'(ok)   {rel}: already patched')
        return
    if old not in s:
        if not expect_present:
            return
        raise SystemExit(f'{rel}: pattern not found')
    p.write_text(s.replace(old, new, count))
    print(f'(patch) {rel}: applied')


# (a) op_cann.hpp: add a cv::MatShape overload declaration. The upstream
#     std::vector<int> constructor stays exactly as it is.
patch('opencv/modules/dnn/src/op_cann.hpp',
      '        CannConstOp(const uint8_t* data, const int dtype, const std::vector<int>& shape, const std::string& name);',
      '        CannConstOp(const uint8_t* data, const int dtype, const std::vector<int>& shape, const std::string& name);\n'
      '        CannConstOp(const uint8_t* data, const int dtype, const cv::MatShape& shape, const std::string& name);')

# (b) op_cann.cpp: the MatShape overload forwards to the upstream
#     std::vector<int> constructor (which keeps upstream's body).
cp = pathlib.Path('opencv/modules/dnn/src/op_cann.cpp')
cs = cp.read_text()
deleg = ('\nCannConstOp::CannConstOp(const uint8_t* data, const int dtype, const cv::MatShape& shape, const std::string& name)\n'
         '    : CannConstOp(data, dtype, std::vector<int>(shape.begin(), shape.end()), name) {}\n')
if deleg.strip() in cs:
    print('(ok)   op_cann.cpp: MatShape forwarding ctor already patched')
elif 'CannConstOp::CannConstOp(const uint8_t* data, const int dtype, const std::vector<int>& shape, const std::string& name)\n{\n' in cs:
    anchor = ('op_ = std::make_shared<ge::op::Const>(name);\n'
              '    op_->set_attr_value(*ge_tensor);\n}\n')
    if anchor not in cs:
        raise SystemExit('op_cann.cpp: anchor not found')
    cp.write_text(cs.replace(anchor, anchor + deleg, 1))
    print('(patch) op_cann.cpp: +1 MatShape forwarding ctor')
else:
    raise SystemExit('op_cann.cpp: std::vector<int> ctor not found')

# (c)(d) cv::MatShape has no front() and cannot be assigned from a
#       std::vector<int> -> fix the 3 assignments that no longer compile.
patch('opencv/modules/dnn/src/layers/gemm_layer.cpp',
      '            shape_C = std::vector<int>{dim};',
      '            shape_C = cv::MatShape(1, dim);')
patch('opencv/modules/dnn/src/layers/matmul_layer.cpp',
      '                if (real_ndims_C == 1 && bias_shape.front() != 1) {',
      '                if (real_ndims_C == 1 && bias_shape[0] != 1) {')
patch('opencv/modules/dnn/src/layers/matmul_layer.cpp',
      '                    bias_shape = std::vector<int>{bias_shape.front()};',
      '                    bias_shape = cv::MatShape(1, bias_shape[0]);')

# (e) all_ops.h -> array_ops.h (1500-op header blows the aarch64 link window)
old_block = '''#ifdef CANN_VERSION_BELOW_6_3_ALPHA002
    #include "op_proto/built-in/inc/all_ops.h" // ge::Conv2D, ...
#else
    #include "built-in/op_proto/inc/all_ops.h" // ge::Conv2D, ...
#endif'''
new_block = '''#ifdef CANN_VERSION_BELOW_6_3_ALPHA002
    #include "op_proto/built-in/inc/array_ops.h" // ge::op::Const/Data/Identity/Reshape/Unsqueeze
#else
    #include "built-in/op_proto/inc/array_ops.h" // ge::op::Const/Data/Identity/Reshape/Unsqueeze
#endif'''
patch('opencv/modules/dnn/src/op_cann.hpp', old_block, new_block)

# (f) per-layer narrow headers
INSERTS = {
    'layers/batch_norm_layer.cpp': ['nn_batch_norm_ops'],
    'layers/concat_layer.cpp': ['split_combination_ops'],
    'layers/convolution_layer.cpp': ['nn_calculation_ops'],
    'layers/deconvolution_layer.cpp': ['nn_calculation_ops'],
    'layers/depth_space_ops_layer.cpp': ['transformation_ops'],
    'layers/elementwise_layers.cpp': ['nonlinear_fuc_ops', 'elewise_calculation_ops'],
    'layers/eltwise_layer.cpp': ['elewise_calculation_ops'],
    'layers/flatten_layer.cpp': ['transformation_ops'],
    'layers/fully_connected_layer.cpp': ['matrix_calculation_ops'],
    'layers/gemm_layer.cpp': ['matrix_calculation_ops'],
    'layers/instance_norm_layer.cpp': ['nn_norm_ops'],
    'layers/layer_norm.cpp': ['nn_norm_ops'],
    'layers/lrn_layer.cpp': ['nn_norm_ops'],
    'layers/matmul_layer.cpp': ['matrix_calculation_ops'],
    'layers/nary_eltwise_layers.cpp': ['elewise_calculation_ops'],
    'layers/padding_layer.cpp': ['pad_ops'],
    'layers/permute_layer.cpp': ['transformation_ops'],
    'layers/pooling_layer.cpp': ['nn_pooling_ops'],
    'layers/reduce_layer.cpp': ['reduce_ops'],
    'layers/resize2_layer.cpp': ['image_ops'],
    'layers/resize_layer.cpp': ['image_ops'],
    'layers/slice_layer.cpp': ['split_combination_ops', 'selection_ops'],
    'layers/softmax_layer.cpp': ['nn_norm_ops'],
}
ANCHOR = '#include "../op_cann.hpp"'
for rel, headers in INSERTS.items():
    p = pathlib.Path('opencv/modules/dnn/src') / rel
    if not p.exists():
        print(f'(skip) {rel}: not present')
        continue
    s = p.read_text()
    if 'built-in/op_proto/inc/' in s:
        continue
    if ANCHOR not in s:
        print(f'(skip) {rel}: anchor missing (file may not need patch in this tag)')
        continue
    block = ANCHOR + '\n' + '\n'.join(
        f'#include "built-in/op_proto/inc/{h}.h"' for h in headers)
    p.write_text(s.replace(ANCHOR, block, 1))
    print(f'(patch) {rel}: +{len(headers)} narrow header(s)')

# (g) OperatorRunner NULL stream fallback
p = pathlib.Path('opencv_contrib/modules/cannops/src/cann_call.cpp')
s = p.read_text()
old_g = '''OperatorRunner& OperatorRunner::run(AscendStream& stream)
{
    aclrtStream rawStream = AscendStreamAccessor::getStream(stream);
    CV_ACL_SAFE_CALL(aclopCompileAndExecute(op.c_str(), inputDesc_.size(), inputDesc_.data(),
                                            inputBuffers_.data(), outputDesc_.size(),
                                            outputDesc_.data(), outputBuffers_.data(), opAttr_,
                                            ACL_ENGINE_SYS, ACL_COMPILE_SYS, NULL, rawStream));
    if (rawStream == nullptr)
        CV_ACL_SAFE_CALL(aclrtSynchronizeStream(rawStream));
    else
    {
        for (const auto& ptr : holder)
            stream.addTensorHolder(ptr);
    }
    return *this;
}'''
new_g = '''OperatorRunner& OperatorRunner::run(AscendStream& stream)
{
    aclrtStream rawStream = AscendStreamAccessor::getStream(stream);
    aclrtStream execStream = rawStream;
    if (execStream == nullptr)
        CV_ACL_SAFE_CALL(aclrtCtxGetCurrentDefaultStream(&execStream));
    CV_ACL_SAFE_CALL(aclopCompileAndExecute(op.c_str(), inputDesc_.size(), inputDesc_.data(),
                                            inputBuffers_.data(), outputDesc_.size(),
                                            outputDesc_.data(), outputBuffers_.data(), opAttr_,
                                            ACL_ENGINE_SYS, ACL_COMPILE_SYS, NULL, execStream));
    CV_ACL_SAFE_CALL(aclrtSynchronizeStream(execStream));
    if (rawStream != nullptr)
    {
        for (const auto& ptr : holder)
            stream.addTensorHolder(ptr);
    }
    return *this;
}'''
if 'aclrtCtxGetCurrentDefaultStream' in s:
    print('(ok)   cann_call.cpp: NULL-stream fallback already present (prior patch), skip')
else:
    patch('opencv_contrib/modules/cannops/src/cann_call.cpp', old_g, new_g)
PY

# Bridge the CANN 9.1.0 library layout for OpenCV's OpenCVFindCANN.cmake,
# then configure and build with WITH_CANN=ON and install to /usr/local/opencv-cann.
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    ARCH_DIR="$(uname -m)-linux" && \
    test -d "/usr/local/Ascend/ascend-toolkit/latest/${ARCH_DIR}" && \
    ln -sfn "/usr/local/Ascend/ascend-toolkit/latest/${ARCH_DIR}" /usr/local/Ascend/ascend-toolkit/latest/acllib && \
    ln -sfn "/usr/local/Ascend/ascend-toolkit/latest/${ARCH_DIR}/lib64" /usr/local/Ascend/ascend-toolkit/latest/lib64 && \
    ln -sfn "/usr/local/Ascend/ascend-toolkit/latest/${ARCH_DIR}/lib64" /usr/local/Ascend/ascend-toolkit/latest/compiler/lib64 && \
    python3 -c "import numpy; print('numpy', numpy.__version__)" && \
    PY_INC="$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["include"])')" && \
    PY_LIBDIR="$(python3 -c 'import sysconfig; print(sysconfig.get_config_var("LIBDIR"))')" && \
    PY_LIB="$(ls ${PY_LIBDIR}/libpython3*.so 2>/dev/null | head -n 1)" && \
    if [ -z "${PY_LIB}" ]; then PY_LIB="$(ls ${PY_LIBDIR}/libpython3*.so.* 2>/dev/null | head -n 1)"; fi && \
    echo "python3 include: ${PY_INC}, library: ${PY_LIB}" && \
    cmake -S /tmp/opencv -B /tmp/opencv/build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/opencv-cann \
        -DWITH_CANN=ON \
        -DBUILD_opencv_world=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_LIST=core,imgproc,imgcodecs,videoio,dnn,python3,cannops \
        -DSOC_VERSION=ascend910b1 \
        -DBUILD_opencv_python3=ON \
        -DBUILD_opencv_python_bindings_generator=ON \
        -DPYTHON_INCLUDE_DIR="${PY_INC}" \
        -DPYTHON_LIBRARY="${PY_LIB}" \
        -DOPENCV_ENABLE_NONFREE=OFF \
        -DOPENCV_DOWNLOAD_MIRROR_ID=gitcode \
        -DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules && \
    cmake --build /tmp/opencv/build --target install --parallel 2 && \
    /usr/local/opencv-cann/bin/opencv_version && \
    echo "/usr/local/opencv-cann/lib" > /etc/ld.so.conf.d/opencv-cann.conf && \
    ldconfig && \
    SITE_DIR="$(python3 -c 'import site; print(site.getsitepackages()[0])')" && \
    CV2_DIR="$(dirname "$(find /usr/local/opencv-cann -type d -name cv2 | head -n 1)")" && \
    echo "${CV2_DIR}" > "${SITE_DIR}/opencv-cann.pth" && \
    LD_LIBRARY_PATH="/usr/local/opencv-cann/lib:${LD_LIBRARY_PATH}" \
    PYTHONPATH="${CV2_DIR}" python3 -c "import cv2; print('cv2', cv2.__version__)" && \
    rm -rf /tmp/opencv /tmp/opencv_contrib

CMD ["/bin/bash"]
