# Overview

## Database

### Mysql

- Primary, Replication 설정
- 8.4.0 버전 이후 Master, Slave 설정 방법이 변경됨 (https://dev.mysql.com/doc/refman/8.0/en/replication-howto.html)

### Postgresql
- Airflow 에서 사용

### Redis
- Airflow 에서 사용

## Message

### Apache Kafka
- kafka-broker-1, kafka-broker-2, kafka-broker-3

### Debezium Connector
- Mysql -> Kafka 로 데이터를 전송하는 Connector

## Searching
- ElasticSearch
- Kibana

## Stream

### Flink
- Kafka 에서 데이터를 읽어서 처리하는 Stream 처리

## Workflow

### Airflow