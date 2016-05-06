#Esecuzione Container MySQL con VOLUME
docker run \
--name mysqldbVol \
-v /home/vagrant/volumes/mysqlvolume:/var/lib/mysql \
-e MYSQL_USER=mysql \
-e MYSQL_PASSWORD=mysql \
-e MYSQL_DATABASE=sample \
-e MYSQL_ROOT_PASSWORD=supersecret \
-p 3306:3306 \
-d mysql


#Creazione tabelle su Mysql (SE NON FATTO IL BKT)
CREATE TABLE HELLOKYEPARTNER
(
ID INT NOT NULL AUTO_INCREMENT,
JOB varchar(100),
CITTA varchar(100),
DATAINSERIMENTO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (ID)
) ;

INSERT INTO HELLOKYEPARTNER (JOB,CITTA) VALUES ('Consulenza per Conte.it',  'ROMA');

#TABELLA OPZIONALE
CREATE TABLE HELLOMYSQL
(
ID INT NOT NULL AUTO_INCREMENT,
NOME varchar(255) NOT NULL,
SOCIETA varchar(100),
CITTA varchar(100),
DATAINSERIMENTO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (ID)
) ;
INSERT INTO HELLOMYSQL (NOME,SOCIETA,CITTA) VALUES ('Giovanni', 'Key Partner', 'ROMA');

#Build immagine con aggiunta DS mysql
docker build --tag repogio/jboss-dsmysql:latest .

#Esecuzione jboss-dsmysql
docker run -d --link mysqldbVol:db -p 8080:8080 -p 9990:9990 --name jbossmysql repogio/jboss-dsmysql

#Test 
http://192.168.33.10:8080/keyweb/resources/customers/
http://192.168.33.10:8080/keyweb/resources/customers/aggiungi/Sky%20Italia/Roma






