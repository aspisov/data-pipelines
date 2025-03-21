# ETL

## Prerequisites

- [Deploying Hadoop cluster](/01_hadoop/README.md)
- [Deploying YARN](/02_yarn/README.md)
- [Deploying Hive](/03_hive/README.md)
- [Spark with YARN](/04_spark/README.md)

## Scripts
All the instruction below combined into one script: [run_etl.sh](run_etl.sh)

## Instructions

1. Activate the virtual environment and spark environment:
```shell
source venv/bin/activate
source ~/.spark_env
```

2. Install prefect:
```shell
pip install prefect
```

3. Run the script:
```shell
python dag.py
```


