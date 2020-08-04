FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	cron \
	rsyslog \
	postfix \
	postfix-ldap \
	opendkim \
	opendkim-tools \
	sasl2-bin \
	libsasl2-modules-ldap \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/spool/postfix && \
	mkdir -p /etc/ssl/localcerts && \
	mkdir -p /etc/postfix

RUN adduser postfix sasl
RUN ln -s /etc/postfix/saslauthd.conf /etc/saslauthd.conf

COPY ./data/postfix/ /etc/postfix/
COPY ./data/saslauthd /etc/default/
COPY ./data/opendkim/ /etc/opendkim/
COPY ./data/opendkim.conf /etc/opendkim.conf

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]