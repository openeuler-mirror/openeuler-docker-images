# Quick reference

- The official DeepSeek-LLM docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# DeepSeek-LLM | openEuler
Current DeepSeek-LLM docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DeepSeek LLM is an advanced language model comprising 67 billion parameters. It has been trained from scratch on a vast dataset of 2 trillion tokens in both English and Chinese. DeepSeek LLM 7B/67B Base and DeepSeek LLM 7B/67B Chat are open source for the research community.

Learn more on [DeepSeek-LLM](https://github.com/deepseek-ai/DeepSeek-LLM).

# Supported tags and respective Dockerfile links
The tag of each `DeepSeek-LLM` docker image is consist of the version of `DeepSeek-LLM` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/deepseek/1.0.0/24.03-lts-sp3/Dockerfile) | DeepSeek-LLM 1.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/deepseek` image from docker

	```
	docker pull openeuler/deepseek:{Tag}
	```

- Run and test `deepseek` container

	```
	docker run -it --rm openeuler/deepseek:{Tag}
	```
	
	From here, users can test DeepSeek-LLM as follows:
	
	**Text Completion:**
	```python
	import torch
	from transformers import AutoTokenizer, AutoModelForCausalLM, GenerationConfig

	model_name = "deepseek-ai/deepseek-llm-7b-base"
	tokenizer = AutoTokenizer.from_pretrained(model_name)
	model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.bfloat16, device_map="auto")
	model.generation_config = GenerationConfig.from_pretrained(model_name)
	model.generation_config.pad_token_id = model.generation_config.eos_token_id

	text = "An attention function can be described as mapping a query and a set of key-value pairs to an output"
	inputs = tokenizer(text, return_tensors="pt")
	outputs = model.generate(**inputs.to(model.device), max_new_tokens=100)

	result = tokenizer.decode(outputs[0], skip_special_tokens=True)
	print(result)
	```

	**Chat Completion:**
	```python
	import torch
	from transformers import AutoTokenizer, AutoModelForCausalLM, GenerationConfig

	model_name = "deepseek-ai/deepseek-llm-7b-chat"
	tokenizer = AutoTokenizer.from_pretrained(model_name)
	model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.bfloat16, device_map="auto")
	model.generation_config = GenerationConfig.from_pretrained(model_name)
	model.generation_config.pad_token_id = model.generation_config.eos_token_id

	messages = [{"role": "user", "content": "Who are you?"}]
	input_tensor = tokenizer.apply_chat_template(messages, add_generation_prompt=True, return_tensors="pt")
	outputs = model.generate(input_tensor.to(model.device), max_new_tokens=100)

	result = tokenizer.decode(outputs[0][input_tensor.shape[1]:], skip_special_tokens=True)
	print(result)
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).