# Homework 1

We are provided with 4 VM:
- jn (JumpNode) 
- nn (NameNode, SecondaryNameNode, DataNode)
- dn-0 (DataNode)
- dn-1 (DataNode)

## VM setup

0. rename all machine from `team-25` to `tmpl` by modifying `/etc/hostname` and reboot

1. generated and distribute
JumpNode ssh key to all other machines

```bash
ssh-keygen
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.103:.ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.104:.ssh/authorized_keys
scp .ssh/id_ed25519.pub 192.168.1.105:.ssh/authorized_keys
```

2. added aliases for all ip addresses to `/etc/hosts` on all machines

```bash
# 127.0.0.1 localhost
127.0.0.1 tmpl-jn

# 192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
192.168.1.105 tmpl-dn-01
```
```bash
# 127.0.0.1 localhost
# 127.0.0.1 tmpl-nn

192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
192.168.1.105 tmpl-dn-01
```

```bash
# 127.0.0.1 localhost
127.0.0.1 tmpl-dn-00

192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
# 192.168.1.104 tmpl-dn-00
192.168.1.105 tmpl-dn-01
```

```bash
# 127.0.0.1 localhost
127.0.0.1 tmpl-dn-01

192.168.1.102 tmpl-jn
192.168.1.103 tmpl-nn
192.168.1.104 tmpl-dn-00
# 192.168.1.105 tmpl-dn-01
```

3. created user `hadoop` on all machines
```bash
sudo adduser hadoop
```
4. 
```bash 
ssh-keygen
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
scp -r .ssh/ tmpl-nn:/home/hadoop
scp -r .ssh/ tmpl-dn-00:/home/hadoop
scp -r .ssh/ tmpl-dn-01:/home/hadoop
```
5. installed hadoop on all machines
```bash
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
scp hadoop-3.4.0.tar.gz tmpl-jn:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-nn:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-dn-00:/home/hadoop
scp hadoop-3.4.0.tar.gz tmpl-dn-01:/home/hadoop
```
6. unzipped hadoop on all machines
```bash
tar -xzvf hadoop-3.4.0.tar.gz
```

## Hadoop setup
1. modify `.profile` on all machines by adding the following lines:
```bash
export HADOOP_HOME=/home/hadoop/hadoop-3.4.0
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```
2. activate the changes and spread `.profile` to all machines
```bash
source .profile
hadoop version
scp .profile tmpl-nn:/home/hadoop
scp .profile tmpl-dn-00:/home/hadoop
scp .profile tmpl-dn-01:/home/hadoop
```
3. specity java path in `hadoop-3.4.0/etc/hadoop/hadoop-env.sh`
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

4. add config to `hadoop-3.4.0/etc/hadoop/core-site.xml`
```xml
<configuration>
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://tmpl-nn:9000</value>
</property>
</configuration>
```

5. add config to `hadoop-3.4.0/etc/hadoop/hdfs-site.xml`
```xml
<configuration>
<property>
    <name>dfs.replication</name>
    <value>3</value>
</property>
</configuration>
```

6. specify workers in `hadoop-3.4.0/etc/hadoop/workers`
```
tmpl-nn
tmpl-dn-00
tmpl-dn-01
```
7. copy modified hadoop files to all machines
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
1. connect to NameNode and run the following
```bash
hadoop-3.4.0/bin/hdfs namenode -format
hadoop-3.4.0/sbin/start-dfs.sh
```




