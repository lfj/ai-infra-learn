FROM milvusdb/milvus:v2.6.16

EXPOSE 19530 9091

HEALTHCHECK --interval=30s --timeout=20s --start-period=90s --retries=3 \
    CMD ["curl", "-f", "http://localhost:9091/healthz"]

CMD ["milvus", "run", "standalone"]
