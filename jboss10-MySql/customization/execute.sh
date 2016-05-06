#!/bin/bash

# Usage: execute.sh [WildFly mode] [configuration file]
#
# The default mode is 'standalone' and default configuration is based on the
# mode. It can be 'standalone.xml' or 'domain.xml'.
JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
echo "=> MYSQL_HOST (explicit): " $MYSQL_HOST
echo "=> MYSQL_PORT (explicit): " $MYSQL_PORT
echo "=> MYSQL (docker host): " $DB_PORT_3306_TCP_ADDR
echo "=> MYSQL (docker port): " $DB_PORT_3306_TCP_PORT
echo "=> MYSQL (k8s host): " $MYSQL_SERVICE_SERVICE_HOST
echo "=> MYSQL (k8s port): " $MYSQL_SERVICE_SERVICE_PORT
echo "=> MYSQL_URI (docker with networking): " $MYSQL_URI
echo "=> MYSQL_DATABASE : " $DB_ENV_MYSQL_DATABASE

$JBOSS_CLI -c << EOF
batch

set CONNECTION_URL=jdbc:mysql://$DB_PORT_3306_TCP_ADDR:$DB_PORT_3306_TCP_PORT/$DB_ENV_MYSQL_DATABASE
echo "Connection URL: " $CONNECTION_URL

# Add MySQL module
module add --name=com.mysql --resources=/opt/jboss/wildfly/customization/mysql-connector-java-5.1.31-bin.jar --dependencies=javax.api,javax.transaction.api

# Add MySQL driver
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-xa-datasource-class-name=com.mysql.jdbc.jdbc2.optional.MysqlXADataSource)

# Add the datasource
data-source add --name=mysqlDS --driver-name=mysql --jndi-name=java:jboss/datasources/ExampleMySQLDS --connection-url=jdbc:mysql://$DB_PORT_3306_TCP_ADDR:$DB_PORT_3306_TCP_PORT/$DB_ENV_MYSQL_DATABASE?useUnicode=true&amp;characterEncoding=UTF-8 --user-name=$DB_ENV_MYSQL_USER --password=$DB_ENV_MYSQL_PASSWORD --use-ccm=false --max-pool-size=25 --blocking-timeout-wait-millis=5000 --enabled=true

# Execute the batch
run-batch
EOF


echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

cp /opt/jboss/wildfly/customization/keyweb.war $JBOSS_HOME/$JBOSS_MODE/deployments/keyweb.war

echo "=> Restarting WildFly"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -c $JBOSS_CONFIG
