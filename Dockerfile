FROM openjdk:8-jre-alpine
LABEL maintainer="Pedric (cxdemosg@gmail.com)"

ARG BUILDENV
ARG IAST_URL=192.168.137.70:8380

RUN apk update && apk add
RUN adduser --system --home /home/easybuggy4sb easybuggy4sb
RUN cd /home/easybuggy4sb/;
RUN chgrp -R 0 /home/easybuggy4sb
RUN chmod -R g=u /home/easybuggy4sb

USER easybuggy4sb
WORKDIR /home/easybuggy4sb

RUN if [ "$BUILDENV" = "TEST" ] ; then \
    apk add ca-certificates libstdc++ glib curl unzip && \
    curl -o cxiast-java-agent.zip http://${IAST_URL}/iast/compilation/download/JAVA && \
    unzip cxiast-java-agent.zip -d /home/easybuggy4sb/cxiast-java-agent && \
    rm -rf cxiast-java-agent.zip && \
    chmod +x /home/easybuggy4sb/cxiast-java-agent/cx-launcher.jar ; fi

# if --build-arg env=TEST, set JAVA_TOOL_OPTIONS to 'CxIAST agent path' or set to null otherwise.
ENV JAVA_TOOL_OPTIONS=${BUILDENV:+"-javaagent:/home/easybuggy4sb/cxiast-java-agent/cx-launcher.jar -Xverify:none"}
ENV JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS}

COPY target/ROOT.war /home/easybuggy4sb/ROOT.war

EXPOSE 8080

CMD java -jar /home/easybuggy4sb/ROOT.war
