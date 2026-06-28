FROM quay.io/coreos/etcd:v3.5.25

ENV ETCD_AUTO_COMPACTION_MODE=revision \
    ETCD_AUTO_COMPACTION_RETENTION=1000 \
    ETCD_QUOTA_BACKEND_BYTES=4294967296 \
    ETCD_SNAPSHOT_COUNT=50000

EXPOSE 2379 2380

HEALTHCHECK --interval=30s --timeout=20s --retries=3 \
    CMD ["etcdctl", "endpoint", "health"]

CMD ["etcd", \
     "-advertise-client-urls=http://etcd:2379", \
     "-listen-client-urls", "http://0.0.0.0:2379", \
     "--data-dir", "/etcd"]
