#!/bin/bash
set -e

# 禁用失效的 docker-engine 源，避免 apt update 失败
for f in /etc/apt/sources.list.d/*docker*; do
  if [ -f "$f" ] && grep -q 'mirrors.aliyun.com/docker-engine' "$f" 2>/dev/null; then
    mv "$f" "${f}.disabled"
    echo "已禁用失效源: $f"
  fi
done

# 基础依赖
apt update && apt install -y wget unzip apt-transport-https ca-certificates

OTEL_VERSION="0.111.0"
PROM_VER="2.54.1"

download_file() {
  local output="$1"
  shift
  for url in "$@"; do
    echo "尝试下载: $url"
    if wget -O "$output" "$url"; then
      return 0
    fi
  done
  echo "下载失败: $output" >&2
  return 1
}

# ========== 1、otelcol-contrib ==========
echo "开始下载 otelcol-contrib..."
OTEL_DEB="otelcol-contrib_${OTEL_VERSION}_linux_amd64.deb"
download_file "$OTEL_DEB" \
  "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/${OTEL_DEB}" \
  "https://ghfast.top/https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/${OTEL_DEB}"
dpkg -i "$OTEL_DEB"
rm -f "$OTEL_DEB"

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