#!/bin/bash

function ConfigureColon {
    KEY="$1"
    VALUE="$2"
    FILE="$3"
    MESSAGE="$4"
    sed -i "s#^\s*$KEY\s*:.*\$#$KEY: $VALUE#g" $FILE
    echo "$MESSAGE"
}

SASLAUTHD_CONF=/etc/postfix/saslauthd.conf
echo "Configure: $SASLAUTHD_CONF"
ConfigureColon "ldap_servers" "ldap://$LDAP_HOSTS" "$SASLAUTHD_CONF" "Set hosts=ldap://$LDAP_HOSTS, LDAP_HOSTS: Required"
ConfigureColon "ldap_search_base" "$LDAP_BASE" "$SASLAUTHD_CONF" "Set ldap_search_base: $LDAP_BASE, LDAP_BASE: Required"
ConfigureColon "ldap_filter" "(uid=%u)" "$SASLAUTHD_CONF" "Set ldap_filter: (uid=%u)"
ConfigureColon "ldap_bind_dn" "$LDAP_BIND_DN" "$SASLAUTHD_CONF" "Set ldap_bind_dn: $LDAP_BIND_DN"
ConfigureColon "ldap_bind_pw" "$LDAP_BIND_PW" "$SASLAUTHD_CONF" "Set ldap_bind_pw: ***"

function ConfigureEq {
    KEY="$1"
    VALUE="$2"
    FILE="$3"
    MESSAGE="$4"
    sed -i "s#^\s*$KEY\s*=.*\$#$KEY=$VALUE#g" $FILE
    echo "$MESSAGE"
}

POSTFIX_MAIN_CF=/etc/postfix/main.cf
echo "Configure: $POSTFIX_MAIN_CF"
ConfigureEq "virtual_mailbox_domains" "$DOMAIN" "$POSTFIX_MAIN_CF" "Set virtual_mailbox_domains=$DOMAIN, DOMAIN Required"
ConfigureEq "myhostname" "$HOSTNAME" "$POSTFIX_MAIN_CF" "Set myhostname=$HOSTNAME, HOSTNAME Required"
LMTP_TRANSPORT="lmtp:inet:$LMTP_HOST:24"
ConfigureEq "virtual_transport" "$LMTP_TRANSPORT" "$POSTFIX_MAIN_CF" "Set virtual_transport=$LMTP_TRANSPORT, LMTP_HOST Required"
ConfigureEq "smtpd_tls_key_file" "$SSL_KEY_PATH" "$POSTFIX_MAIN_CF" "Set smtpd_tls_key_file=$SSL_KEY_PATH, SSL_KEY_PATH Required"
ConfigureEq "smtpd_tls_cert_file" "$SSL_CERT_PATH" "$POSTFIX_MAIN_CF" "Set smtpd_tls_cert_file=$SSL_CERT_PATH, SSL_CERT_PATH Required"


function ConfigureWS {
    KEY="$1"
    VALUE="$2"
    FILE="$3"
    MESSAGE="$4"
    sed -i "s#^\s*$KEY\s*.*\$#$KEY $VALUE#g" $FILE
    echo "$MESSAGE"
}

OPENDKIM_CONF=/etc/opendkim.conf
echo "Configure: $OPENDKIM_CONF"
ConfigureWS "Domain" "$DOMAIN" "$OPENDKIM_CONF" "Set Domain $DOMAIN"
ConfigureWS "Selector" "$DKIM_SELECTOR" "$OPENDKIM_CONF" "Set Selector $DKIM_SELECTOR, DKIM_SELECTOR: Required"
ConfigureWS "KeyFile" "$DKIM_KEY_PATH" "$OPENDKIM_CONF" "Set KeyFile $DKIM_KEY_PATH, DKIM_KEY_PATH: Required"

if [ ! -f $DKIM_KEY_PATH ]; then
    echo "Generate DKIM key of $DKIM_SELECTOR because there is no DKIM key in $DKIM_KEY_PATH."
	opendkim-genkey -d $DOMAIN -b 2048 -s $DKIM_SELECTOR
	mv $DKIM_SELECTOR.private $DKIM_KEY_PATH
	chmod 400 $DKIM_KEY_PATH
	mv $DKIM_SELECTOR.txt $DKIM_KEY_PATH.txt
fi
echo "DKIM Record of $DKIM_SELECTOR (cat $DKIM_KEY_PATH.txt)"
cat $DKIM_KEY_PATH.txt

echo "Setting cron"
echo '0 4 * * sat root postfix reload' >> /etc/crontab
echo '* * * * * root postfix reload' >> /etc/crontab

echo "Adding host configurations into postfix jail"
rm -rf /var/spool/postfix/etc
mkdir -p /var/spool/postfix/etc
cp -v /etc/hosts /var/spool/postfix/etc/hosts
cp -v /etc/services /var/spool/postfix/etc/services
cp -v /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
echo "Adding name resolution tools into postfix jail"
rm -rf "/var/spool/postfix/lib"
mkdir -p "/var/spool/postfix/lib/$(uname -m)-linux-gnu"
cp -v /lib/$(uname -m)-linux-gnu/libnss_* "/var/spool/postfix/lib/$(uname -m)-linux-gnu/"

service rsyslog start
service saslauthd start
service opendkim start
service cron start

postfix start-fg
