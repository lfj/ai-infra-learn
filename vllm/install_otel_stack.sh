#!/bin/bash
set -e

# 基础依赖
apt update && apt install -y wget unzip apt-transport-https ca-certificates

OTEL_VERSION="0.111.0"
PROM_VER="2.54.1"

# ========== 1、otelcol-contrib 【gh代理加速】 ==========
echo "开始下载 otelcol-contrib..."
wget https://shturl.cc//https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb
dpkg -i otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb
rm -f otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb

# ========== 2、Prometheus 【清华github-release镜像】 ==========
echo "开始下载 prometheus..."
wget https://mirrors.tuna.tsinghua.edu.cn/github-release/prometheus/prometheus/v${PROM_VER}/prometheus-${PROM_VER}.linux-amd64.tar.gz
tar zxf prometheus-${PROM_VER}.linux-amd64.tar.gz
mv prometheus-${PROM_VER}.linux-amd64 /opt/prometheus
rm -rf prometheus-${PROM_VER}.linux-amd64.tar.gz

# ========== 3、Grafana 使用清华APT源，彻底抛弃github下载 ==========
echo "配置Grafana清华源"
wget -q -O- https://mirrors.tuna.tsinghua.edu.cn/grafana/apt/gpg.key | gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://mirrors.tuna.tsinghua.edu.cn/grafana/apt/ stable main" | tee /etc/apt/sources.list.d/grafana.list
apt update
apt install -y grafana

echo "===== 安装完成，继续写入配置 ====="