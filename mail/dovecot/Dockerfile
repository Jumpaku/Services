FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /var/mail \
&& mkdir -p /etc/ssl/localcerts \
&& mkdir -p /etc/dovecot

RUN apt-get update && apt-get install -y \
	openssl \
	dovecot-imapd \
	dovecot-lmtpd \
	dovecot-ldap \
	dovecot-sieve \
	dovecot-managesieved \
&& rm -rf /var/lib/apt/lists/*

COPY ./data/ /etc/dovecot/

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
