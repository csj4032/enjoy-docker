CREATE TABLE IF NOT EXISTS departments
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
INSERT INTO departments (name) VALUES ('Engineering');
INSERT INTO departments (name) VALUES ('Design');
INSERT INTO departments (name) VALUES ('Finance');
INSERT INTO departments (name) VALUES ('Marketing');
INSERT INTO departments (name) VALUES ('Sales');
INSERT INTO departments (name) VALUES ('HR');
INSERT INTO departments (name) VALUES ('Legal');

CREATE TABLE IF NOT EXISTS employees
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(50)    NOT NULL,
    department  INT    NOT NULL,
    salary      DECIMAL(10, 2) NOT NULL
);

INSERT INTO employees (name, department, salary) VALUES ('Alice', 1, 75000.00);
INSERT INTO employees (name, department, salary) VALUES ('Bob', 2, 65000.00);
INSERT INTO employees (name, department, salary) VALUES ('Carol', 3, 60000.00);
INSERT INTO employees (name, department, salary) VALUES ('David', 4, 60000.00);
INSERT INTO employees (name, department, salary) VALUES ('Eric', 5, 60000.00);
INSERT INTO employees (name, department, salary) VALUES ('Frank', 6, 60000.00);
INSERT INTO employees (name, department, salary) VALUES ('Grace', 1, 95000.00);
INSERT INTO employees (name, department, salary) VALUES ('Heidi', 2, 90000.00);
INSERT INTO employees (name, department, salary) VALUES ('Ivan', 3, 80000.00);
INSERT INTO employees (name, department, salary) VALUES ('Judy', 4, 85000.00);
INSERT INTO employees (name, department, salary) VALUES ('Kevin', 5, 70000.00);
INSERT INTO employees (name, department, salary) VALUES ('Laura', 6, 75000.00);
INSERT INTO employees (name, department, salary) VALUES ('Michael', 1, 80000.00);

CREATE TABLE IF NOT EXISTS customers
(
    id                  INT             PRIMARY KEY AUTO_INCREMENT,
    name                VARCHAR(50)     NOT NULL,
    email               VARCHAR(200)    NOT NULL,
    address             VARCHAR(200),
    phone_number        VARCHAR(200),
    company             VARCHAR(200)
);

CREATE USER 'debezium'@'%' IDENTIFIED BY 'debezium';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium'@'%';

FLUSH PRIVILEGES;