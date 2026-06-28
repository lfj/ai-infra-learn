#!/usr/bin/env python3
"""Quick sanity check for the local Milvus deployment."""

from pymilvus import Collection, CollectionSchema, DataType, FieldSchema, connections, utility


def main() -> None:
    connections.connect(alias="default", host="127.0.0.1", port="19530")

    collection_name = "demo_collection"
    if utility.has_collection(collection_name):
        utility.drop_collection(collection_name)

    fields = [
        FieldSchema(name="id", dtype=DataType.INT64, is_primary=True, auto_id=False),
        FieldSchema(name="embedding", dtype=DataType.FLOAT_VECTOR, dim=128),
    ]
    schema = CollectionSchema(fields=fields, description="Milvus docker smoke test")
    collection = Collection(name=collection_name, schema=schema)

    index_params = {
        "index_type": "IVF_FLAT",
        "metric_type": "L2",
        "params": {"nlist": 128},
    }
    collection.create_index(field_name="embedding", index_params=index_params)

    vectors = [[float(i % 10) for _ in range(128)] for i in range(10)]
    collection.insert([list(range(10)), vectors])
    collection.flush()
    collection.load()

    results = collection.search(
        data=[vectors[0]],
        anns_field="embedding",
        param={"metric_type": "L2", "params": {"nprobe": 10}},
        limit=3,
        output_fields=["id"],
    )

    print("Milvus connection OK")
    print(f"Collection: {collection_name}")
    print(f"Top hits: {results[0].ids}")


if __name__ == "__main__":
    main()
