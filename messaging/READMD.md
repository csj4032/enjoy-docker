curl -X POST -H "Content-Type: application/json" --data @mysql-source-connector.json http://localhost:8083/connectors
curl -X GET http://localhost:8083/connectors/mysql-source-connector/status
curl -X DELETE http://localhost:8083/connectors/mysql-source-connector