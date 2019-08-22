#!/bin/bash

function ConfigureColon {
    KEY="$1"
    VALUE="$2"
    FILE="$3"
    MESSAGE="$4"
    sed -i "s#^\s*$KEY\s*:.*\$#$KEY=$VALUE#g" $FILE
    echo "$MESSAGE"
}

SASLAUTHD_CONF=/etc/postfix/saslauthd.conf
echo "Configure: $SASLAUTHD_CONF"
ConfigureColon "ldap_servers" "ldap://$LDAP_HOSTS" "$SASLAUTHD_CONF" "Set hosts=ldap://$LDAP_HOSTS, LDAP_HOSTS: Required"
ConfigureColon "ldap_search_base" "$LDAP_BASE" "$SASLAUTHD_CONF" "Set ldap_search_base: $LDAP_BASE, LDAP_BASE: Required"
ConfigureColon "ldap_filter" "(uid=%u)" "$SASLAUTHD_CONF" "Set ldap_filter: (uid=%u)"

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

echo "Generate DKIM key of $DKIM_SELECTOR if there is no DKIM key in $DKIM_KEY_PATH"
if [ ! -f $DKIM_KEY_PATH ]; then
	opendkim-genkey -d $DOMAIN -b 2048 -s $DKIM_SELECTOR
	mv $DKIM_SELECTOR.private $DKIM_KEY_PATH
	chmod 400 $DKIM_KEY_PATH
	mv $DKIM_SELECTOR.txt $DKIM_KEY_PATH.txt
fi
echo "DKIM Record of $DKIM_SELECTOR (cat $DKIM_KEY_PATH.txt)"
cat $DKIM_KEY_PATH.txt

#############################################
# Add dependencies into the chrooted folder
#############################################

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



#########################################
# Start services
#########################################

function services {
	echo ""
	echo "#########################################"
	echo "$1 rsyslog"
	echo "#########################################"
	service rsyslog $1

	echo ""
	echo "#########################################"
	echo "$1 SASL"
	echo "#########################################"
	service saslauthd $1

	#if isDkimEnabled; then
	echo ""
	echo "#########################################"
	echo "$1 OpenDKIM"
	echo "#########################################"
	service opendkim $1
	#fi

	echo ""
	echo "#########################################"
	echo "$1 Postfix"
	echo "#########################################"
	postfix $1
}

# Set signal handlers
trap "services stop; exit 0" SIGINT SIGTERM
trap "services reload" SIGHUP

# Start services
services start

# Redirect logs to stdout
tail -F "/var/log/mail.log" &
wait $!


# supervisord --nodaemon