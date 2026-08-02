#!/bin/bash
OMP_NUM_THREADS=4

#OTEL_SERVICE_NAME=vllm-autodl-instance
#OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://127.0.0.1:4317
#OTEL_EXPORTER_OTLP_TRACES_INSECURE=true
#OTEL_TRACES_SAMPLER=parentbased_always_on
OMP_NUM_THREADS=4

python -m vllm.entrypoints.openai.api_server \
--model /root/autodl-tmp/models/models/qwen--Qwen2.5-7B-Instruct/snapshots/master \
--served-model-name qwen-7b \
--host 0.0.0.0 \
--port 6006 \
--max-model-len 4096 \
#--otlp-traces-endpoint=http://127.0.0.1:4317 \
#--collect-detailed-traces all \
#--gpu-memory-utilization 0.85 \
#--trust-remote-code
