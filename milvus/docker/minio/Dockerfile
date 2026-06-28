FROM minio/minio:RELEASE.2024-05-28T17-19-04Z

ENV MINIO_ROOT_USER=minioadmin \
    MINIO_ROOT_PASSWORD=minioadmin

EXPOSE 9000 9001

HEALTHCHECK --interval=30s --timeout=20s --retries=3 \
    CMD ["mc", "ready", "local"]

ENTRYPOINT ["minio"]
CMD ["server", "/minio_data", "--console-address", ":9001"]
