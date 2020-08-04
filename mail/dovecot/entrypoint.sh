#!/bin/bash

function Configure {
    KEY="$1"
    VALUE="$2"
    FILE="$3"
    MESSAGE="$4"
    sed -i "s?^#*\s*$KEY\s*=.*\$?$KEY=$VALUE?g" $FILE
    echo "$MESSAGE"
}

DOVECOT_LDAP_CONF=/etc/dovecot/dovecot-ldap.conf.ext
#LDAP_FILTER="(uid=%n)"
echo "Configure: $DOVECOT_LDAP_CONF"
Configure "hosts" "$LDAP_HOSTS" "$DOVECOT_LDAP_CONF" "Set hosts=$LDAP_HOSTS, LDAP_BASE: Required"
Configure "dn" "$LDAP_DN" "$DOVECOT_LDAP_CONF" "Set dn=$LDAP_DN"
Configure "dnpass" "$LDAP_DNPASS" "$DOVECOT_LDAP_CONF" "Set dnpass=***"
Configure "base" "$LDAP_BASE" "$DOVECOT_LDAP_CONF" "Set base=$LDAP_BASE, LDAP_BASE: Required"
Configure "user_filter" "(uid=%n)" "$DOVECOT_LDAP_CONF" "Set user_filter=(uid=%n)"
Configure "pass_filter" "(uid=%n)" "$DOVECOT_LDAP_CONF" "Set pass_filter=(uid=%n)"
Configure "pass_attrs" "uid=user" "$DOVECOT_LDAP_CONF" "Set pass_attrs=uid=user"

DOVECOT_SSL_CONF=/etc/dovecot/conf.d/10-ssl.conf
echo "Configure: $DOVECOT_SSL_CONF"
Configure "ssl_key" "<$SSL_KEY_PATH" "$DOVECOT_SSL_CONF" "Set ssl_key=<$SSL_KEY_PATH, SSL_KEY_PATH: Required"
Configure "ssl_cert" "<$SSL_CERT_PATH" "$DOVECOT_SSL_CONF" "Set ssl_cert=<$SSL_CERT_PATH, SSL_CERT_PATH: Required"

DOVECOT_MAIL_CONF=/etc/dovecot/conf.d/10-mail.conf
DOVECOT_SIEVE_CONF=/etc/dovecot/conf.d/90-sieve.conf
INBOX_PATH="/var/mail/%n" # %n: user part in user@domain
echo "Configure: $DOVECOT_MAIL_CONF, $DOVECOT_SIEVE_CONF"
Configure "mail_location" "maildir:$INBOX_PATH" "$DOVECOT_MAIL_CONF" "Set mail_location=maildir:$INBOX_PATH, INBOX_PATH: Required"
Configure "sieve_dir" "$INBOX_PATH.sieve" "$DOVECOT_SIEVE_CONF" "Set sieve_dir=$INBOX_PATH.sieve"
Configure "sieve" "$INBOX_PATH.sieve/sieve" "$DOVECOT_SIEVE_CONF" "Set sieve=$INBOX_PATH.sieve/sieve"

echo "Setting cron"
echo '0  4  *  *  sat root dovecot reload && echo "$(date) cron: dovecot reload" > /proc/$(cat /var/run/dovecot/master.pid)/fd/1 2>&1' >> /etc/crontab

echo "Start cron"
cron

echo "Start dovecot"
dovecot -F
