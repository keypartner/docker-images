# Web application example with Wildfly 10 and MySql containers  

## Run MySQL containerwith VOLUMES (specifies the volume to you more comfortable)
```
docker run \
--name mysqldbVol \
-v /home/vagrant/volumes/mysqlvolume:/var/lib/mysql \
-e MYSQL_USER=mysql \
-e MYSQL_PASSWORD=mysql \
-e MYSQL_DATABASE=sample \
-e MYSQL_ROOT_PASSWORD=supersecret \
-p 3306:3306 \
-d mysql
```

## Create mysql tables only the first time
```
CREATE TABLE CUSTOMERS
(
ID INT NOT NULL AUTO_INCREMENT,
NAME varchar(100),
CITY varchar(100),
INSERTIONDATE date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (ID)
) ;
```

## Build wildfly images with [dockerfile](https://github.com/keypartner/docker-images/blob/master/jboss10-MySql/Dockerfile)
```
docker build --tag jboss-dsmysql:latest .
```

## Run WildFly container with link to mysqldbvol
```
docker run -d --link mysqldbVol:db -p 8080:8080 -p 9990:9990 --name jbossmysql jboss-dsmysql
```

## Test with ip of your linux machine
- To get list of customers
http://192.168.33.10:8080/keyweb/resources/customers/
- To add new customers
http://192.168.33.10:8080/keyweb/resources/customers/add/RedHat/Roma

Bye
