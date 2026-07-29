#!/bin/bash
set -e

# 1. 安装基础依赖
apt update && apt install -y wget unzip systemd

# ========== 安装 OpenTelemetry Collector Contrib ==========
OTEL_VERSION="0.111.0"
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb
dpkg -i otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb
rm -f otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb

# ========== 安装 Prometheus ==========
PROM_VER="2.54.1"
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VER}/prometheus-${PROM_VER}.linux-amd64.tar.gz
tar zxf prometheus-${PROM_VER}.linux-amd64.tar.gz
mv prometheus-${PROM_VER}.linux-amd64 /opt/prometheus
rm -rf prometheus-${PROM_VER}.linux-amd64.tar.gz

# ========== 安装 Grafana ==========
wget https://dl.grafana.com/oss/release/grafana_11.2.0_amd64.deb
dpkg -i grafana_11.2.0_amd64.deb || apt -f install -y
rm -f grafana_11.2.0_amd64.deb

echo "==== 二进制安装完成，接下来写入配置 ===="