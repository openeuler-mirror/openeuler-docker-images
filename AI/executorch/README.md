# Quick reference

- The offical ExecuTorch docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# ExecuTorch | openEuler

**ExecuTorch** is PyTorch's unified solution for deploying AI models on-device—from smartphones to microcontrollers—built for privacy, performance, and portability. It powers Meta's on-device AI across **Instagram, WhatsApp, Quest 3, Ray-Ban Meta Smart Glasses**, and [more](https://docs.pytorch.org/executorch/main/success-stories.html).

Deploy **LLMs, vision, speech, and multimodal models** with the same PyTorch APIs you already know—accelerating research to production with seamless model export, optimization, and deployment. No manual C++ rewrites. No format conversions. No vendor lock-in.

- **🔒 Native PyTorch Export** — Direct export from PyTorch. No .onnx, .tflite, or intermediate format conversions. Preserve model semantics.
- **⚡ Production-Proven** — Powers billions of users at [Meta with real-time on-device inference](https://engineering.fb.com/2025/07/28/android/executorch-on-device-ml-meta-family-of-apps/).
- **💾 Tiny Runtime** — 50KB base footprint. Runs on microcontrollers to high-end smartphones.
- **🚀 [12+ Hardware Backends](https://docs.pytorch.org/executorch/main/backends-overview.html)** — Open-source acceleration for Apple, Qualcomm, ARM, MediaTek, Vulkan, and more.
- **🎯 One Export, Multiple Backends** — Switch hardware targets with a single line change. Deploy the same model everywhere.


# Supported tags and respective Dockerfile links

The tag of each KleidiAI docker image is consist of the version of KleidiAI and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.0.0-torch2.9.0-python3.11-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/executorch/1.0.0-torch2.9.0-python3.11/24.03-lts-sp2/Dockerfile)| ExecuTorch 1.0.0 on openEuler 24.03-LTS-SP2 | aarch64 |

# Usage

## Quick start 1: supported devices

- ARM AArch64

## Quick start 2: setup environment using container

```bash
# Update the KleidiAI image
docker run --rm --name executorch -it --entrypoint bash openeuler/executorch:latest
```
### Export and Deploy in 3 Steps

```python
import torch
from executorch.exir import to_edge_transform_and_lower
from executorch.backends.xnnpack.partition.xnnpack_partitioner import XnnpackPartitioner

# 1. Export your PyTorch model
model = MyModel().eval()
example_inputs = (torch.randn(1, 3, 224, 224),)
exported_program = torch.export.export(model, example_inputs)

# 2. Optimize for target hardware (switch backends with one line)
program = to_edge_transform_and_lower(
    exported_program,
    partitioner=[XnnpackPartitioner()]  # CPU | CoreMLPartitioner() for iOS | QnnPartitioner() for Qualcomm
).to_executorch()

# 3. Save for deployment
with open("model.pte", "wb") as f:
    f.write(program.buffer)

# Test locally via ExecuTorch runtime's pybind API (optional)
from executorch.runtime import Runtime
runtime = Runtime.get()
method = runtime.load_program("model.pte").load_method("forward")
outputs = method.execute([torch.randn(1, 3, 224, 224)])
```

### Run on Device

**[C++](https://docs.pytorch.org/executorch/main/using-executorch-cpp.html)**
```cpp
#include <executorch/extension/module/module.h>
#include <executorch/extension/tensor/tensor.h>

Module module("model.pte");
auto tensor = make_tensor_ptr({2, 2}, {1.0f, 2.0f, 3.0f, 4.0f});
auto outputs = module.forward(tensor);
```

**[Swift (iOS)](https://docs.pytorch.org/executorch/main/ios-section.html)**
```swift
import ExecuTorch

let module = Module(filePath: "model.pte")
let input = Tensor<Float>([1.0, 2.0, 3.0, 4.0], shape: [2, 2])
let outputs = try module.forward(input)
```

**[Kotlin (Android)](https://docs.pytorch.org/executorch/main/android-section.html)**
```kotlin
val module = Module.load("model.pte")
val inputTensor = Tensor.fromBlob(floatArrayOf(1.0f, 2.0f, 3.0f, 4.0f), longArrayOf(2, 2))
val outputs = module.forward(EValue.from(inputTensor))
```

### LLM Example: Llama

Export Llama models using the [`export_llm`](https://docs.pytorch.org/executorch/main/llm/export-llm.html) script or [Optimum-ExecuTorch](https://github.com/huggingface/optimum-executorch):

```bash
# Using export_llm
python -m executorch.extension.llm.export.export_llm --model llama3_2 --output llama.pte

# Using Optimum-ExecuTorch
optimum-cli export executorch \
  --model meta-llama/Llama-3.2-1B \
  --task text-generation \
  --recipe xnnpack \
  --output_dir llama_model
```

Run on-device with the LLM runner API:

**[C++](https://docs.pytorch.org/executorch/main/llm/run-with-c-plus-plus.html)**
```cpp
#include <executorch/extension/llm/runner/text_llm_runner.h>

auto runner = create_llama_runner("llama.pte", "tiktoken.bin");
executorch::extension::llm::GenerationConfig config{
    .seq_len = 128, .temperature = 0.8f};
runner->generate("Hello, how are you?", config);
```

**[Swift (iOS)](https://docs.pytorch.org/executorch/main/llm/run-on-ios.html)**
```swift
import ExecuTorchLLM

let runner = TextRunner(modelPath: "llama.pte", tokenizerPath: "tiktoken.bin")
try runner.generate("Hello, how are you?", Config {
    $0.sequenceLength = 128
}) { token in
    print(token, terminator: "")
}
```

**Kotlin (Android)** — [API Docs](https://docs.pytorch.org/executorch/main/javadoc/org/pytorch/executorch/extension/llm/package-summary.html) • [Demo App](https://github.com/meta-pytorch/executorch-examples/tree/main/llm/android/LlamaDemo)
```kotlin
val llmModule = LlmModule("llama.pte", "tiktoken.bin", 0.8f)
llmModule.load()
llmModule.generate("Hello, how are you?", 128, object : LlmCallback {
    override fun onResult(result: String) { print(result) }
    override fun onStats(stats: String) { }
})
```

For multimodal models (vision, audio), use the [MultiModal runner API](extension/llm/runner) which extends the LLM runner to handle image and audio inputs alongside text. See [Llava](examples/models/llava/README.md) and [Voxtral](examples/models/voxtral/README.md) examples.

See [examples/models/llama](examples/models/llama/README.md) for complete workflow including quantization, mobile deployment, and advanced options.

**Next Steps:**
- 📖 [Step-by-step tutorial](https://docs.pytorch.org/executorch/main/getting-started.html) — Complete walkthrough for your first model
- ⚡ [Colab notebook](https://colab.research.google.com/drive/1qpxrXC3YdJQzly3mRg-4ayYiOjC6rue3?usp=sharing) — Try ExecuTorch instantly in your browser
- 🤖 [Deploy Llama models](examples/models/llama/README.md) — LLM workflow with quantization and mobile demos

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)⁠.
