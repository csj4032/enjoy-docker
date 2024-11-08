## Configure the Primary Server
```sql
ALTER USER 'genius'@'%' IDENTIFIED WITH mysql_native_password BY 'genius';
GRANT REPLICATION SLAVE ON *.* TO 'genius'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;
```

## Configure the Replica Server
- Master Server 에서 확인한 정보를 입력
```sql
CHANGE MASTER TO MASTER_HOST='mysql-primary', MASTER_USER='genius', MASTER_PASSWORD='genius', MASTER_LOG_FILE='mysql-bin.XXXXXX', MASTER_LOG_POS=XXX;
START SLAVE;
SHOW SLAVE STATUS;
```
- 8.4.0 버전 이후 Master, Slave 설정 방법이 변경됨 (https://dev.mysql.com/doc/refman/8.0/en/replication-howto.html)