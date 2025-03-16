from onetl.connection import Hive, SparkHDFS
from onetl.db import DBWriter
from onetl.file import FileDFReader
from onetl.file.format import CSV
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = (
    SparkSession.builder.master("yarn")
    .appName("spark-with-yarn")
    .config("spark.sql.warehouse.dir", "/user/hive/warehouse")
    .config("spark.hive.metastore.uris", "thrift://tmpl-jn:9083")
    .enableHiveSupport()
    .getOrCreate()
)

hdfs = SparkHDFS(host="tmpl-nn", port=9000, spark=spark, cluster="test")
reader = FileDFReader(
    connection=hdfs, format=CSV(delimiter=",", header=True), source_path="/input"
)
df = reader.run(["top_spotify_songs.csv"])
print(df.count())
print(df.printSchema())
print(df.rdd.getNumPartitions())

hive = Hive(spark=spark, cluster="test")
print(hive.check())

# default partitions
writer = DBWriter(
    connection=hive,
    table="test.spark_partitions",
    options={"if_exists": "replace_entire_table"},
)
writer.run(df)

# one partition
writer = DBWriter(
    connection=hive,
    table="test.one_partition",
    options={"if_exists": "replace_entire_table"},
)
writer.run(df.coalesce(1))

# partitions by year
writer = DBWriter(
    connection=hive,
    table="test.partitions_by_year",
    options={"if_exists": "replace_entire_table", "partitionBy": "album_release_year"},
)
writer.run(
    df.withColumn("album_release_year", F.year("album_release_date").substr(0, 4))
)
