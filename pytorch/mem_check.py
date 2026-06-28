import torch

if torch.cuda.is_available():
    used = torch.cuda.memory_allocated() / 1024 ** 3
    peak = torch.cuda.max_memory_allocated() / 1024 ** 3
    print(f"当前显存占用: {used:.2f} GB")
    print(f"显存峰值: {peak:.2f} GB")
else:
    print("CUDA不可用")