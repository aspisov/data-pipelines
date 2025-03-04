# data-pipelines

## Disclaimer
We are provided with 4 VM:
- JumpNode: 192.168.1.102, 176.109.91.27 (tmpl-jn) - accessible from the internet
- NameNode: 192.168.1.103 (tmpl-nn)
- DataNode-0: 192.168.1.104 (tmpl-dn-0)
- DataNode-1: 192.168.1.105 (tmpl-dn-1)

Everywhere I use any of these machines, you should replace it with your own username and IP address.

Machine that you should run current command on is specified in the comments. Example:
```bash
# hadoop@tmpl-nn
hadoop-3.4.0/sbin/start-dfs.sh
```


1. [Deploying Hadoop cluster](/01_hadoop/README.md)
2. [Deploying YARN](/02_yarn/README.md)
3. [Running MapReduce](/2.5_mapreduce/README.md)
4. [Deploying Hive](/03_hive/README.md)
