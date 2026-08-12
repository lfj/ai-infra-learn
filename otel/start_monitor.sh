#!/bin/bash
cd ~/ai-monitor

# 1.启动Prometheus
pkill prometheus
./bin/prometheus \
--config.file=./config/prometheus.yml \
--storage.tsdb.path=./data/prom \
--web.listen-address=127.0.0.1:9091 \
--web.enable-lifecycle &

sleep 2

# 2.启动Jaeger
pkill jaeger
./bin/jaeger \
--query.http-server=127.0.0.1:16686 \
--collector.http-server=127.0.0.1:14268 &

sleep 2

# 3.启动Grafana
pkill grafana-server
./bin/grafana/bin/grafana-server \
--homepath=./bin/grafana \
cfg:default.paths.data=./data/grafana \
cfg:default.paths.logs=./logs \
cfg:default.paths.plugins=./plugins \
cfg:default.http.address=127.0.0.1:3000 &

echo "========服务启动完成========"
echo "Prometheus: http://127.0.0.1:9091"
echo "Jaeger UI:  http://127.0.0.1:16686"
echo "Grafana:    http://127.0.0.1:3000"