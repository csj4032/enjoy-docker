## Library File Download

- libs 폴더에 필요한 File Download
- [flink-sql-connector-mysql-cdc-3.0-SNAPSHOT.jar](https://mvnrepository.com/artifact/com.ververica/flink-sql-connector-mysql-cdc/3.0.0)
- [flink-shaded-hadoop-2-uber-2.7.5-10.0.jar](https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/2.7.5-10.0/flink-shaded-hadoop-2-uber-2.7.5-10.0.jar)
- [iceberg-flink-runtime-1.16-1.3.1.jar](https://repo.maven.apache.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.16/1.3.1/iceberg-flink-runtime-1.16-1.3.1.jar)

## Start Flink CDC

```shell
# Flink Cluster Start
docker compose up

# Flink SQL Client Start
docker compose run sql-client
```

## Kafka Connect SQL

```sql
SET execution.checkpointing.interval = 3s;
    
CREATE TABLE genius_employess_kafka_source
(
    id         BIGINT,
    name       STRING,
    department BIGINT,
    salary     DECIMAL(10, 2)
) WITH (
      'connector' = 'kafka',
      'topic' = 'debezium.mysql.source.genius.employees',
      'properties.bootstrap.servers' = 'kafka-broker-1:9091,kafka-broker-2:9091,kafka-broker-3:9091',
      'properties.group.id' = 'debezium-mysql-source-flink',
      'scan.startup.mode' = 'earliest-offset',
      'format' = 'debezium-json'
);

SELECT id, name, department, salary FROM genius_employess_kafka_source;

CREATE TABLE genius_employees_iceberg_sink
(
    id         DECIMAL(20, 0) NOT NULL,
    name       STRING,
    department DECIMAL(20, 0),
    salary     DECIMAL(10, 2),
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'iceberg',
      'catalog-name' = 'iceberg_catalog',
      'catalog-type' = 'hadoop',
      'warehouse' = 'file:///tmp/warehouse',
      'format-version' = '2'
      );

INSERT INTO genius_employees_iceberg_sink SELECT id, name, department, salary FROM genius_employess_kafka_source;
 ```

## MySQL Connect Flink SQL

```sql
SET execution.checkpointing.interval = 3s;
    
CREATE TABLE genius_departments_mysql_source 
(
    id         DECIMAL(20, 0) NOT NULL,
    name       STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = 'mysql-primary',
      'port' = '3306',
      'username' = 'root',
      'password' = 'root',
      'database-name' = 'genius',
      'table-name' = 'departments');

SELECT id, name FROM genius_departments_mysql_source;

CREATE TABLE genius_departments_iceberg_sink
(
    id         DECIMAL(20, 0) NOT NULL,
    name       STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'iceberg',
      'catalog-name' = 'iceberg_catalog',
      'catalog-type' = 'hadoop',
      'warehouse' = 'file:///tmp/warehouse',
      'format-version' = '2'
      );

INSERT INTO genius_departments_iceberg_sink SELECT id, name FROM genius_departments_mysql_source;
```

## Iceberg File 확인
```bash
docker-compose run sql-client tree /tmp/iceberg/warehouse/default_database/
```

## Reference
- https://nightlies.apache.org/flink/flink-cdc-docs-master/docs/connectors/flink-sources/tutorials/build-real-time-data-lake-tutorial/
