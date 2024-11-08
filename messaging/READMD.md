## Debezium Mysql User 설정

- database mysql init.sql 미리 유저 생

```sql
CREATE
USER 'debezium'@'%' IDENTIFIED BY 'debezium';
GRANT
SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT
ON *.* TO 'debezium' IDENTIFIED BY 'debezium';
FLUSH
PRIVILEGES;
```

## Debezium Connector 설정

```bash
# Mysql Source Connector 설정
curl -X POST -H "Content-Type: application/json" --data @mysql-source-connector.json http://localhost:8083/connectors

# Mysql Source Connector 설정 확인
curl -X GET http://localhost:8083/connectors/mysql-source-connector/status

# Mysql Source Connector 설정 삭제
curl -X DELETE http://localhost:8083/connectors/mysql-source-connector
```

## Kafka Listener 설정

- Docker Port Mapping None 인증, SASL 인증 등을 함께 설정
- ~~SSL 인증, SASL_SSL 인증, ACL 설정~~

```
ports:
    - 19092:9092
    - 19094:9094  
environment:
    - KAFKA_LISTENERS: PLAINTEXT://:9091,PLAINTEXT_HOST://:9092,SASL_PLAINTEXT://:9093,SASL_PLAINTEXT_HOST://:9094
    - KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka-broker-1:9091,PLAINTEXT_HOST://localhost:19092,SASL_PLAINTEXT://kafka-broker-1:9093,SASL_PLAINTEXT_HOST://localhost:19094
    - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_PLAINTEXT_HOST:SASL_PLAINTEXT
# Or
ports:
    - 9092:9092
    - 9093:9093  
environment:
    - KAFKA_LISTENERS: PLAINTEXT://:9092,SASL_PLAINTEXT://:9093
    - KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka-broker-1:9092,PLAINTEXT_HOST://localhost:9092,SASL_PLAINTEXT://kafka-broker-1:9093,SASL_PLAINTEXT_HOST://localhost:9093
    - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_PLAINTEXT_HOST:SASL_PLAINTEXT
```

- 19092:9092, 19094:9094 는 Docker Port Mapping 을 사용하는 경우는 Kafka 특성 때문에 가능 함
1. Kafka 클라이언트가 브로커에 연결 19092
2. Docker Port Mapping 을 사용하는 경우 19092:9092 로 연결
3. Docker 내부 Kafka Broker 9092 로 연결 성공
4. Kafka Client 초기 연결 후 메타데이터 요청
5. Kafka Broker 는 Kafka Client 에게 advertised.listeners 설정을 반환
6. Kafka Client 는 해당 주소로 계속 연결 시도 19092

##  ~~ExtractNewRecordState 설정~~
- ~~Debezium Connector 설정에 추가~~
```
"transforms": "unwrap",
"transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState"
```

## Reference
- https://kafka.apache.org/documentation/#connect_transforms
- https://debezium.io/documentation/reference/stable/connectors/mysql.html