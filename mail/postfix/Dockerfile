FROM alpine:3.10

RUN apk --update add postfix postfix-ldap busybox-extras openssl


RUN mkdir -p /etc/ssl/localcerts/
RUN openssl genrsa \
    -out /etc/ssl/localcerts/mail.key.pem
RUN openssl req -new \
    -key /etc/ssl/localcerts/mail.key.pem \
    -out /etc/ssl/localcerts/mail.csr.pem \
    -subj "/CN=smtp"
RUN openssl x509 -req -days 3650 \
    -in /etc/ssl/localcerts/mail.csr.pem \
    -signkey /etc/ssl/localcerts/mail.key.pem \
    -out /etc/ssl/localcerts/mail.cert.pem

COPY ./data/main.cf /etc/postfix/
COPY ./data/master.cf /etc/postfix/

CMD [ "postfix", "start-fg" ]
