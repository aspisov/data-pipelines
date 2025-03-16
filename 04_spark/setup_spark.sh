#!/bin/bash

# Setup Spark environment automatically
echo "Setting up Spark environment..."

# Install required packages
sudo apt install -y python3-venv python3-pip

# Download and extract Spark
wget https://archive.apache.org/dist/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
tar -xzvf spark-3.5.3-bin-hadoop3.tgz

# Setup environment variables
cat > ~/.spark_env << EOL
export HADOOP_CONF_DIR="/home/hadoop/hadoop-3.4.0/etc/hadoop"
export HIVE_HOME="/home/hadoop/apache-hive-4.0.0-alpha-2-bin"
export HIVE_CONF_DIR=\$HIVE_HOME/conf
export HIVE_AUX_JARS_PATH=\$HIVE_HOME/lib*
export PATH=\$PATH:\$HIVE_HOME/bin
export SPARK_LOCAL_IP=$(hostname -I | awk '{print $1}')
export SPARK_DIST_CLASSPATH="home/hadoop/spark-3.5.3-bin-hadoop3/jars/*:/home/hadoop/hadoop-3.4.0/etc/hadoop/*:/home/hadoop/hadoop-3.4.0/share/hadoop/common/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/common/*:/home/hadoop/hadoop-3.4.0/share/hadoop/hdfs/*:/home/hadoop/hadoop-3.4.0/share/hadoop/hdfs/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/yarn/*:/home/hadoop/hadoop-3.4.0/share/hadoop/yarn/lib/*:/home/hadoop/hadoop-3.4.0/share/hadoop/mapreduce/*:/home/hadoop/hadoop-3.4.0/share/hadoop/mapreduce/lib/*:/home/hadoop/apache-hive-4.0.0-alpha-2-bin/*:/home/hadoop/apache-hive-4.0.0-alpha-2-bin/lib/*"
export SPARK_HOME="/home/hadoop/spark-3.5.3-bin-hadoop3"
export PYTHONPATH=\$(ZIPS=("\$SPARK_HOME"/python/lib/*.zip); IFS=:; echo "\${ZIPS[*]}"):\$PYTHONPATH
export PATH=\$SPARK_HOME/bin:\$PATH
EOL

echo "source ~/.spark_env" >> ~/.bashrc
source ~/.spark_env

# Create Python virtual environment and install dependencies
python3 -m venv venv
source venv/bin/activate
pip install pip -U
pip install ipython
pip install onetl[files]
pip install gdown

echo "Spark setup completed successfully!"
echo "Use 'source ~/.spark_env' to load Spark environment variables in a new terminal."
echo "To activate Python virtual environment, use 'source venv/bin/activate'" 