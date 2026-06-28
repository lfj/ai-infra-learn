import torch
# 当前真实占用显存
print(torch.cuda.memory_allocated() / 1024**3)
# 预分配预留显存
print(torch.cuda.memory_reserved() / 1024**3)
# 峰值显存
print(torch.cuda.max_memory_allocated() / 1024**3)