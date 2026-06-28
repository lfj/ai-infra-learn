#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ACTION="${1:-up}"

case "$ACTION" in
  up|start)
    docker compose up -d --build
    echo ""
    echo "Milvus is starting..."
    echo "  gRPC:    localhost:19530"
    echo "  Metrics: http://localhost:9091/healthz"
    echo "  MinIO:   http://localhost:9001 (minioadmin / minioadmin)"
    ;;
  down|stop)
    docker compose down
    ;;
  restart)
    docker compose down
    docker compose up -d --build
    ;;
  logs)
    docker compose logs -f "${2:-standalone}"
    ;;
  ps|status)
    docker compose ps
    ;;
  *)
    echo "Usage: $0 {up|down|restart|logs|status}"
    exit 1
    ;;
esac
