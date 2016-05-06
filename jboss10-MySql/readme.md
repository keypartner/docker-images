# Web application example with Wildfly 10 and MySql containers  

## Run container MySQL with any VOLUMES 
```
docker run --name mysqldbVol -v /home/vagrant/volumes/mysqlvolume:/var/lib/mysql -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql 
-e MYSQL_DATABASE=sample -e MYSQL_ROOT_PASSWORD=supersecret -p 3306:3306 -d mysql
```

## Create mysql tables only the first time
CREATE TABLE HELLOKYEPARTNER
(
ID INT NOT NULL AUTO_INCREMENT,
JOB varchar(100),
CITTA varchar(100),
DATAINSERIMENTO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (ID)
) ;

## Build immagine con aggiunta DS mysql
docker build --tag jboss-dsmysql:latest .

## Esecuzione jboss-dsmysql
docker run -d --link mysqldbVol:db -p 8080:8080 -p 9990:9990 --name jbossmysql repogio/jboss-dsmysql

## Test 
http://192.168.33.10:8080/keyweb/resources/customers/
http://192.168.33.10:8080/keyweb/resources/customers/aggiungi/Sky%20Italia/Roma
