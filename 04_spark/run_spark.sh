#!/bin/bash

# Run Spark job with all the necessary setup
echo "Preparing to run Spark job..."

# Source environment variables
source ~/.spark_env
source venv/bin/activate

# Check if data exists, if not download it
if [ ! -f "top_spotify_songs.csv" ]; then
  echo "Downloading dataset..."
  gdown --id 1SqQLjyas6h-GreSW-_rVwLKX7VBak82E -O top_spotify_songs.csv.zip
  unzip top_spotify_songs.csv.zip
fi

# Put data to HDFS
echo "Uploading data to HDFS..."
hdfs dfs -mkdir -p /input
hdfs dfs -put -f top_spotify_songs.csv /input

# Start Hive Metastore in the background
echo "Starting Hive Metastore..."
nohup hive --hiveconf hive.server2.enable.doAs=false --hiveconf hive.security.authorization.enable=false --service metastore > metastore.log 2>&1 &
METASTORE_PID=$!

# Wait for metastore to start
echo "Waiting for Hive Metastore to start..."
sleep 10

# Run the Spark script
echo "Running Spark job..."
python3 script.py

# Output success message
echo "Spark job completed!"
echo "To view results, connect to Hive with:"
echo "apache-hive-4.0.0-alpha-2-bin/bin/beeline -u jdbc:hive2://tmpl-jn:5433 -n scott -p tiger"
echo ""
echo "Example queries:"
echo "USE test;"
echo "SHOW TABLES;"
echo "SELECT * FROM spark_partitions LIMIT 5;"
echo "SELECT * FROM one_partition LIMIT 5;"
echo "SELECT * FROM partitions_by_year LIMIT 5;"