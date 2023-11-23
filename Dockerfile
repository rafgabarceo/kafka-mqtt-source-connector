FROM docker.io/maven:3.9.5-eclipse-temurin-11

FROM docker.io/maven:3.9.5-ibm-semeru-11-focal
COPY . /
RUN mvn install
RUN /bin/bash -c "mkdir -p /usr/share/java/kafka"
RUN /bin/bash -c "cp /target/*with-dependencies.jar /usr/share/java/kafka/"

FROM docker.io/ubuntu/kafka:latest
COPY source-connect-mqtt.properties /opt/kafka/config/
RUN /bin/bash -c "echo 'plugin.path=/usr/share/java,/usr/local/share/kafka/plugins,/usr/local/share/java/' >> /opt/kafka/config/connect-standalone.properties"

CMD /opt/kafka/bin/connect-standalone.sh /opt/kafka/config/connect-standalone.properties /opt/kafka/config/source-connect-mqtt.properties
