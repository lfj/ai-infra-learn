#!/bin/bash
CUDA_VISIBLE_DEVICES=0
python -m vllm.entrypoints.openai.api_server \
--model /root/autodl-tmp/models/Qwen2.5-7B-Instruct-AWQ \
--quantization awq \
--served-model-name qwen-7b \
--host 0.0.0.0 \
--port 6006 \
--max-model-len 4096 \
--gpu-memory-utilization 0.82 \
--swap-space 8 \
--enable-prefix-caching \
--enable-chunked-prefill \
--max-num-seqs 64 \
--max-num-batched-tokens 4096 \
--disable-log-requests \
--load-format awq