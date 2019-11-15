FROM alpine:3.8

RUN export -p
WORKDIR /home/openldap
RUN apk --update add openldap openldap-back-mdb openldap-clients

RUN mkdir -p /run/openldap && mkdir -p /etc/openldap/slapd.d && mkdir -p /var/lib/openldap/openldap-data

COPY ./data/slapd.conf /home/openldap
COPY ./data/init.sh /home/openldap
RUN chmod +x init.sh

CMD [ "./init.sh" ]