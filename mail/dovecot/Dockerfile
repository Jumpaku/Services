FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	cron \
	dovecot-imapd \
	dovecot-lmtpd \
	dovecot-ldap \
	dovecot-sieve \
	dovecot-managesieved \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/localcerts && \
	mkdir -p /etc/dovecot && \
	mkdir -p /var/mail

COPY ./dovecot-conf/ /etc/dovecot/
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
