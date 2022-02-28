FROM maven:3-jdk-11

LABEL maintainer="base2Services"
LABEL source="https://github.com/base2Services/build-containers/tree/master/maven-jdk11"

RUN apt-get update && apt-get install protobuf-compiler gettext -y

RUN \
    curl -O http://repo1.maven.org/maven2/io/takari/aether/takari-local-repository/0.11.3/takari-local-repository-0.11.3.jar \
    && curl -O http://repo1.maven.org/maven2/io/takari/takari-filemanager/0.8.2/takari-filemanager-0.8.3.jar \
    && curl -O http://repo1.maven.org/maven2/io/takari/maven/takari-smart-builder/0.4.0/takari-smart-builder-0.4.0.jar \
    && mv takari-* $MAVEN_HOME/lib/ext
