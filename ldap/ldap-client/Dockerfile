FROM alpine:3.8

RUN apk --update add openldap openldap-clients
WORKDIR /home/data
COPY ./data /home/data
RUN chmod +x init.sh
RUN chmod +x modify.sh
RUN chmod +x display.sh
RUN chmod +x run.sh

ENTRYPOINT [ "./run.sh" ]
CMD [ "init" ]
