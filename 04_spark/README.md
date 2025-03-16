# Spark

## Prerequisites
[Running Hadoop cluster](/01_hadoop/README.md)<br>
[Running YARN](/02_yarn/README.md)<br>
[Running Hive](/03_hive/README.md)

## Scripts



## Instructions

#### Setup Spark
1. Install venv & pip
```sh
# team@tmpl-jn
sudo apt install python3-venv
sudo apt install python3-pip
```
2. Install Spark 3.5.3 and extract it
```sh
# hadoop@tmpl-jn
wget https://archive.apache.org/dist/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
tar -xzvf spark-3.5.3-bin-hadoop3.tgz
```
3. Setup environment variables
```sh
# hadoop@tmpl-jn
export HADOOP_CONF_DIR="/home/hadoop/hadoop-3.4.0/etc/hadoop"
export HIVE_HOME="/home/hadoop/apache-hive-4.0.0-alpha-2-bin"
export HIVE_CONF_DIR=$HIVE_HOME/conf
export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib*
export PATH=$PATH:$HIVE_HOME/bin
export SPARK_LOCAL_IP=192.168.1.102 # should be your own jump node IP
export SPARK_DIST_CLASSPATH="home/hadoop/spark-3.5.3-bin-hadoop3/jars/*:/home/hadoop/hadoop-3.4.0/etc/hadoop/*:/home/hadoop/hadoop-3.4.0/share/hadoop/common/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/common/*:/home/hadoop/hadoop-3.4.0/share/hadoop/hdfs/*:/home/hadoop/hadoop-3.4.0/share/hadoop/hdfs/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/yarn/*:/home/hadoop/hadoop-3.4.0/share/hadoop/yarn/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/mapreduce/*:/home/hadoop/hadoop-3.4.0/share/hadoop/mapreduce/lib/*:/home/hadoop/apache-hive-4.0.0-alpha-2-bin/*:/home/hadoop/apache-hive-4.0.0-alpha-2-bin/lib/*"
export SPARK_HOME="/home/hadoop/spark-3.5.3-bin-hadoop3"
export PYTHONPATH=$(ZIPS=("$SPARK_HOME"/python/lib/*.zip); IFS=:; echo "${ZIPS[*]}"):PYTHONPATH
export PATH=$SPARK_HOME/bin:$PATH
```

4. Create venv
```sh
# hadoop@tmpl-jn
python3 -m venv venv
source venv/bin/activate
```

5. Install dependencies
```sh
pip install pip -U
pip install ipython
pip install onetl[files]
```

### Run Spark
1. Download data from Google Drive (you can use your own data instead)
```sh
# hadoop@tmpl-jn
pip install gdown
gdown --id 1SqQLjyas6h-GreSW-_rVwLKX7VBak82E -O top_spotify_songs.csv.zip
unzip top_spotify_songs.csv.zip
```
2. Put data to HDFS
```sh
# hadoop@tmpl-jn
hdfs dfs -mkdir /input
hdfs dfs -put top_spotify_songs.csv /input
```

3. Run script
```sh
# hadoop@tmpl-jn
python3 script.py
```

4. Connect to Hive
```sh
# hadoop@tmpl-jn
apache-hive-4.0.0-alpha-2-bin/bin/beeline -u jdbc:hive2://tmpl-jn:5433 -n scott -p tiger
```

5. Check new tables in Hive
```sql
USE test;
SHOW TABLES;
SELECT * FROM spark_partitions LIMIT 5;
SELECT * FROM one_partition LIMIT 5;
SELECT * FROM partitions_by_year LIMIT 5;
```

