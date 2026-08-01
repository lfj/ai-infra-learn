#!/bin/bash

export OTEL_SERVICE_NAME="vllm-autodl-instance"
export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="http://127.0.0.1:4317"
export OTEL_EXPORTER_OTLP_TRACES_INSECURE=true
export OTEL_TRACES_SAMPLER="parentbased_always_on"
export OMP_NUM_THREADS=4

pkill -f "vllm serve"

vllm serve Qwen2.5-7B-Instruct \
--host 0.0.0.0 \
--port 8000 \
--otlp-traces-endpoint=http://127.0.0.1:4317 \
--collect-detailed-traces all \
--gpu-memory-utilization 0.9
