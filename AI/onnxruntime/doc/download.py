import os
from onnxruntime.transformers.models.gpt2.gpt2_helper import Gpt2Helper, MyGPT2LMHeadModel
from transformers import AutoConfig
import torch


model_name_or_path = "gpt2"

cache_dir = os.path.join(".", "cache_models")
if not os.path.exists(cache_dir):
    os.makedirs(cache_dir)

config = AutoConfig.from_pretrained(model_name_or_path, cache_dir=cache_dir)
model = MyGPT2LMHeadModel.from_pretrained(model_name_or_path, config=config, cache_dir=cache_dir)
device = torch.device("cpu")
model.eval().to(device)

print(model.config)