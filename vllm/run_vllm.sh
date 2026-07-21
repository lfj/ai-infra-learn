#!/bin/bash
OMP_NUM_THREADS=4
python -m vllm.entrypoints.openai.api_server \
--model /root/autodl-tmp/models/qwen/Qwen2.5-7B-Instruct \
--served-model-name qwen-7b \
--host 0.0.0.0 \
--port 6006 \
--max-model-len 4096 \
--gpu-memory-utilization 0.85 \
--trust-remote-code