FROM alpine:3.10

RUN apk --update add dovecot dovecot-ldap dovecot-lmtpd busybox-extras

COPY ./data/conf.d/10-auth.conf /etc/dovecot/conf.d/
COPY ./data/conf.d/10-ssl.conf /etc/dovecot/conf.d/
COPY ./data/conf.d/10-mail.conf /etc/dovecot/conf.d/
COPY ./data/conf.d/10-master.conf /etc/dovecot/conf.d/
COPY ./data/dovecot-ldap.conf.ext /etc/dovecot/

RUN mkdir -p /var/vmail/jumpaku/mail

CMD [ "dovecot", "-F" ]
