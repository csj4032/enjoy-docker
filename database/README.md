## Configure the Master Server
```sql
ALTER USER 'genius'@'%' IDENTIFIED WITH mysql_native_password BY 'genius';
GRANT REPLICATION SLAVE ON *.* TO 'genius'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;

USE genius;

CREATE TABLE customers
(
    id   INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255)       NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO customers (name) VALUES ('Alice');

```

## Configure the Replica Server
```sql
CHANGE MASTER TO
    MASTER_HOST='mysql-primary',
    MASTER_USER='genius',
    MASTER_PASSWORD='genius',
    MASTER_LOG_FILE='mysql-bin.XXXXXX',
    MASTER_LOG_POS=XXX;

START SLAVE;

SHOW SLAVE STATUS;

SHOW SLAVE STATUS;
```