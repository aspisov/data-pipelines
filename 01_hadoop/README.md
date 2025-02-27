# Hadoop deployment


## VM setup

1. start with connecting to jn which is accessible from the internet
```bash
ssh team@176.109.91.27
```

2. generated and distribute
JumpNode ssh key to all other machines (from jn)

```bash
ssh-keygen
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.103:.ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.104:.ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.105:.ssh/authorized_keys
```

3. add aliases for all ip addresses by modifying `/etc/hosts` on all machines (from jn, nn, dn-0, dn-1)

```bash
# tmpl-jn
127.0.0.1 tmpl-jn

192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
192.168.1.105 tmpl-dn-01
```
```bash
# tmpl-nn
192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
192.168.1.105 tmpl-dn-01
```

```bash
# tmpl-dn-00
127.0.0.1 tmpl-dn-00

192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.105 tmpl-dn-01
```

```bash
# tmpl-dn-01
127.0.0.1 tmpl-dn-01

192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
```

4. created user `hadoop` on all machines (from jn, nn, dn-0, dn-1)
```bash
sudo adduser hadoop
```
5. switch to user `hadoop` and generate ssh key (from jn)
```bash 
sudo -i -u hadoop
ssh-keygen
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
scp -r .ssh/ tmpl-nn:/home/hadoop
scp -r .ssh/ tmpl-dn-00:/home/hadoop
scp -r .ssh/ tmpl-dn-01:/home/hadoop
```
6. installed hadoop on all machines (from jn)
```bash
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
scp hadoop-3.4.0.tar.gz tmpl-jn:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-nn:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-dn-00:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-dn-01:/home/hadoop
```
7. unzipped hadoop on all machines (from jn, nn, dn-0, dn-1)
```bash
tar -xzvf hadoop-3.4.0.tar.gz
```

## Hadoop setup

1. check that java version satisfies hadoop requirements: it should be Java 8 or Java 11 (from jn)
```bash
java -version
```
2. find java location (from jn)
```bash
which java
readlink -f /usr/bin/java
```

3. modify `.profile` on all machines by adding the following lines (from jn):
```bash
export HADOOP_HOME=/home/hadoop/hadoop-3.4.0
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 # real java path from previous step
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```
4. activate the changes and spread `.profile` to all machines (from jn)
```bash
source .profile
hadoop version
scp .profile tmpl-nn:/home/hadoop
scp .profile tmpl-dn-00:/home/hadoop
scp .profile tmpl-dn-01:/home/hadoop
```
5. specity java path in `hadoop-3.4.0/etc/hadoop/hadoop-env.sh` (from jn)
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

6. add config to `hadoop-3.4.0/etc/hadoop/core-site.xml` (from jn)
```xml
<configuration>
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://tmpl-nn:9000</value>
</property>
</configuration>
```

7. add config to `hadoop-3.4.0/etc/hadoop/hdfs-site.xml` (from jn)
```xml
<configuration>
<property>
    <name>dfs.replication</name>
    <value>3</value>
</property>
</configuration>
```

8. specify workers in `hadoop-3.4.0/etc/hadoop/workers` (from jn)
```
tmpl-nn
tmpl-dn-00
tmpl-dn-01
```

9. copy modified hadoop files to all machines (from jn)
```bash
# hadoop-env.sh
scp hadoop-env.sh tmpl-nn:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp hadoop-env.sh tmpl-dn-00:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp hadoop-env.sh tmpl-dn-01:/home/hadoop/hadoop-3.4.0/etc/hadoop

# core-site.xml
scp core-site.xml tmpl-nn:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp core-site.xml tmpl-dn-00:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp core-site.xml tmpl-dn-01:/home/hadoop/hadoop-3.4.0/etc/hadoop

# hdfs-site.xml
scp hdfs-site.xml tmpl-nn:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp hdfs-site.xml tmpl-dn-00:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp hdfs-site.xml tmpl-dn-01:/home/hadoop/hadoop-3.4.0/etc/hadoop

# workers
scp workers tmpl-nn:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp workers tmpl-dn-00:/home/hadoop/hadoop-3.4.0/etc/hadoop
scp workers tmpl-dn-01:/home/hadoop/hadoop-3.4.0/etc/hadoop
```

## Run Hadoop
1. connect to NameNode and run the following (from nn)
```bash
hadoop-3.4.0/bin/hdfs namenode -format
hadoop-3.4.0/sbin/start-dfs.sh
```

2. check that everything is running (from nn, dn-0, dn-1)
```bash
jps
```




