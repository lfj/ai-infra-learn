from modelscope import snapshot_download

# 1. 原版FP16对话模型（Qwen2.5-7B-Instruct）
model_dir = snapshot_download(
    "qwen/Qwen2.5-7B-Instruct",
    cache_dir="/root/autodl-tmp/models",  # 强制存在数据盘
    revision="master"
)

# 2. 4bit AWQ量化版（vLLM专用，省显存，优先下这个）
# model_dir = snapshot_download(
#     "Qwen/Qwen2.5-7B-Instruct-AWQ",
#     cache_dir="/root/autodl-tmp/models",
#     revision="master"
# )

print("模型完整路径：", model_dir)
