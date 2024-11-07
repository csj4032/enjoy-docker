## Start Flink CDC
```shell
docker compose up

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
      'properties.bootstrap.servers' = '172.19.0.8:49092,172.19.0.9:39092,172.19.0.10:29092',
      'properties.group.id' = 'debezium-mysql-source-flink',
      'format' = 'debezium-json'
      );

SELECT * FROM genius_employess;
 ```

## MYSQL connect SQL
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
      'table-name' = 'employees',
      'server-time-zone' = 'Asia/Seoul'
      );

SELECT *
FROM genius_employees_source;

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

INSERT INTO genius_employees_sink
select *
from genius_employees_source;



CREATE TABLE genius_customers_source
(
    id              DECIMAL(20, 0) NOT NULL,
    name            STRING,
    email      STRING,
    address    STRING,
    pthone_number STRING,
    company    STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = 'mysql-primary',
      'port' = '3306',
      'username' = 'root',
      'password' = 'root',
      'database-name' = 'genius',
      'table-name' = 'customers',
      'server-time-zone' = 'Asia/Seoul'
      );

SELECT * FROM genius_customers_source;


CREATE TABLE genius_customers_sink
(
    id              DECIMAL(20, 0) NOT NULL,
    name            STRING,
    email      STRING,
    address    STRING,
    pthone_number STRING,
    company    STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'iceberg',
      'catalog-name' = 'iceberg_catalog',
      'catalog-type' = 'hadoop',
      'warehouse' = 'file:///tmp/iceberg/warehouse',
      'format-version' = '2'
      );


INSERT INTO genius_customers_sink select * from genius_customers_source;
```





docker-compose exec sql-client tree /tmp/iceberg/warehouse/default_database/


https://nightlies.apache.org/flink/flink-cdc-docs-master/docs/connectors/flink-sources/tutorials/build-real-time-data-lake-tutorial/