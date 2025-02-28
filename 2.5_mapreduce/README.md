## Running MapReduce

1. Install data and move it to the Hadoop cluster:
```bash
# hadoop@tmpl-jn
wget https://raw.githubusercontent.com/aspisov/data-pipelines/main/2.5_mapreduce/color_data.tsv
hdfs dfs -put color_data.tsv /test
```
2. Create `map.py` and `reduce.py` files and copy content from [map.py](./map.py) and [reduce.py](./reduce.py).
```bash
# hadoop@tmpl-jn
vim map.py  
vim reduce.py
```
3. Run simple MapReduce.
```bash
cat color_data.tsv | python3 map.py | sort | python3 reduce.py
```
4. Run MapReduce with Hadoop.
```bash 
mapred streaming \
    -fs file:/// \
    -jt local \
    -files map.py,reduce.py \
    -input /test/color_data.tsv \
    -output /output \
    -mapper map.py \
    -reducer reduce.py
```