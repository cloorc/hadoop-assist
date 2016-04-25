# Hadoop Assistant Toolset 1.0

## Directory Structure

> `tree -L 1 -d`

```
.
├── apache-hive-2.0.0
├── prepare-assist
├── hadoop-2.7.0
└── hadoop-2.7.2
```

## Usage

> Before HDFS or HIVE server being started, import settings from [`Hadoop Assistant Toolset`](https://github.com/soiff/hadoop-assist).

```bash
$ source prepare-assist/hadoop.sh 2.7.2
$ source prepare-assist/hive.sh 2.0.0
$ start-dfs.sh
$ schematool -initSchema -dbType derby
$ beeline -u jdbc:hive2://
```

> Have fun with Hadoop!
