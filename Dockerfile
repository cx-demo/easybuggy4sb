FROM openjdk:8-jre-alpine
LABEL maintainer="Pedric (cxdemosg@gmail.com)"

RUN apk update && apk add
RUN adduser --system --home /home/easybuggy4sb easybuggy4sb
RUN cd /home/easybuggy4sb/;
RUN chgrp -R 0 /home/easybuggy4sb
RUN chmod -R g=u /home/easybuggy4sb

USER easybuggy4sb
WORKDIR /home/easybuggy4sb

COPY target/ROOT.war /home/easybuggy4sb/ROOT.war

EXPOSE 8080

CMD java -jar /home/easybuggy4sb/ROOT.war

