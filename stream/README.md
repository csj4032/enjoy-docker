## Start Flink CDC
```shell
# Flink Cluster Start
docker compose up

# Flink SQL Client Start
docker compose run sql-client
```
## Kafka Connect SQL
```sql
CREATE TABLE kafka_genius_employess
(
    id         BIGINT,
    name       STRING,
    department STRING,
    salary     DECIMAL(10, 2)
) WITH (
      'connector' = 'kafka',
      'topic' = 'debezium.mysql.source.genius.employees',
      'properties.bootstrap.servers' = 'kafka-broker-1:9091,kafka-broker-2:9091,kafka-broker-3:9091',
      'properties.group.id' = 'debezium-mysql-source-flink',
      'format' = 'debezium-json'
      );

SELECT id, name, department, salary FROM kafka_genius_employess;
 ```

## MySQL Connect Flink SQL
```sql
CREATE TABLE genius_employees_source
(
    id         DECIMAL(20, 0) NOT NULL,
    name       STRING,
    department STRING,
    salary     DECIMAL(10, 2),
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = 'mysql-primary',
      'port' = '3306',
      'username' = 'root',
      'password' = 'root',
      'database-name' = 'genius',
      'table-name' = 'employees');
SELECT id, name, department, salary FROM genius_employees_source;

CREATE TABLE genius_employees_sink
(
    id         DECIMAL(20, 0) NOT NULL,
    name       STRING,
    department STRING,
    salary     DECIMAL(10, 2),
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'iceberg',
      'catalog-name' = 'iceberg_catalog',
      'catalog-type' = 'hadoop',
      'warehouse' = 'file:///tmp/iceberg/warehouse',
      'format-version' = '2'
      );

INSERT INTO genius_employees_sink SELECT id, name, department, salary FROM genius_employees_source;
```
## Reference
- https://nightlies.apache.org/flink/flink-cdc-docs-master/docs/connectors/flink-sources/tutorials/build-real-time-data-lake-tutorial/
