FROM alpine:3.10

RUN apk --update add dovecot dovecot-ldap dovecot-lmtpd busybox-extras

#COPY 10-auth.conf /etc/dovecot/conf.d/
#COPY 10-mail.conf /etc/dovecot/conf.d/
#COPY dovecot-ldap.conf.ext /etc/dovecot/
#COPY 10-master.conf /etc/dovecot/conf.d/

CMD [ "dovecot", "-F" ]
