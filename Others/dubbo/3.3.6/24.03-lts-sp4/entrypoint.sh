#!/bin/bash
set -e

cd /home/nacos
sh bin/startup.sh -m standalone

cd /home/dubbo-quickstart
if [ -f ./pom.xml.template ]; then
    envsubst < ./pom.xml.template > ./pom.xml
fi

chmod a+x ./mvnw
./mvnw clean install -Dmaven.test.skip
./mvnw compile -pl quickstart-service exec:java -Dexec.mainClass=org.apache.dubbo.samples.quickstart.QuickStartApplication