from onetl.connection import Hive, SparkHDFS
from onetl.db import DBWriter
from onetl.file import FileDFReader
from onetl.file.format import CSV
from prefect import flow, task
from pyspark.sql import SparkSession
from pyspark.sql import functions as F


@task
def get_spark_session():
    spark = (
        SparkSession.builder.master("yarn")
        .appName("spark-with-yarn")
        .config("spark.sql.warehouse.dir", "/user/hive/warehouse")
        .config("spark.hive.metastore.uris", "thrift://tmpl-jn:9083")
        .enableHiveSupport()
        .getOrCreate()
    )
    return spark


@task
def stop_spark_session(spark):
    spark.stop()


@task
def extract_data(spark):
    hdfs = SparkHDFS(host="tmpl-nn", port=9000, spark=spark, cluster="test")
    reader = FileDFReader(
        connection=hdfs, format=CSV(delimiter=",", header=True), source_path="/input"
    )
    df = reader.run(["top_spotify_songs.csv"])
    return df


@task
def transform_data(df):
    df = df.withColumn("album_release_year", F.year("album_release_date").substr(0, 4))
    return df


@task
def load_data(spark, df):
    hive = Hive(spark=spark, cluster="test")
    writer = DBWriter(
        connection=hive,
        table="test.spark_partitions_with_prefect",
        options={"if_exists": "replace_entire_table"},
    )
    writer.run(df)


@flow
def etl_flow():
    spark = get_spark_session()
    df = extract_data(spark)
    df = transform_data(df)
    load_data(spark, df)
    stop_spark_session(spark)


if __name__ == "__main__":
    etl_flow()
