FROM jboss/wildfly:latest

RUN /opt/jboss/wildfly/bin/add-user.sh admin adminkey --silent

ADD customization /opt/jboss/wildfly/customization/

CMD ["/opt/jboss/wildfly/customization/execute.sh"]