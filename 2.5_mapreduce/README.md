## Running MapReduce

1. Create `map.py` and `reduce.py` files and copy content from [map.py](./map.py) and [reduce.py](./reduce.py).
```bash
# hadoop@tmpl-jn
vim map.py  
vim reduce.py
```
2. Run simple MapReduce.
```bash
cat data-20241101-structure-20180828.csv | python3 map.py | python3 reduce.py 
```