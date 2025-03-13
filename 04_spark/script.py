from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from onetl.connection import SparkHDFS, Hive
from onetl.file import FileDFReader
from onetl.file.format import CSV
from onetl.db import DBWriter

spark = SparkSession.builder \
                    .master("yarn") \
                    .appName("spark-with-yarn") \
                    .config("spark.sql.warehouse.dir", "/user/hive/warehouse") \
                    .config("spark.hive.metastore.uris", "thrift://tmpl-jn:5433") \
                    .enableHiveSupport() \
                    .getOrCreate()

hdfs = SparkHDFS(host="tmpl-nn", port=9000, spark=spark, cluster="test")
reader = FileDFReader(connection=hdfs, format=CSV(delimiter=",", header=True), source_path="/input")
df = reader.run(["top_spotify_songs.csv"])
# print(df.count())
# print(df.printSchema())
# print(df.rdd.getNumPartitions())
hive = Hive(spark=spark, cluster="test")
hive.check()
writer = DBWriter(connection=hive, table="test.spark_partitions", options={"if_exists": "replace_entire_table"})
writer.run(df)