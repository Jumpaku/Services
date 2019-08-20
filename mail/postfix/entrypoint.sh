#!/bin/bash

#########################################
# Setup conf
#########################################

# Set LDAP conf: ldap_servers (ex: ldap://ldap)
if [ -n "$LDAP_HOSTS" ]; then
	sed -i "s|^ldap_servers\s*:.*$|ldap_servers: ldap://$LDAP_HOSTS|" /etc/postfix/saslauthd.conf
else
	echo "LDAP_HOSTS Required"
fi

# Set LDAP conf: ldap_search_base (ex: base=dc=mail, dc=example, dc=org)
if [ -n "$LDAP_BASE" ]; then
	sed -i "s/^ldap_search_base\s*:.*$/ldap_search_base: $LDAP_BASE/" /etc/postfix/saslauthd.conf
else
	echo "LDAP_BASE Required"
fi

# Set LDAP conf: ldap_filter (ex: uid=%u)
if [ -n "$LDAP_USER_FIELD" ]; then
	sed -i "s/^ldap_filter\s*:.*$/ldap_filter: $LDAP_USER_FIELD=%u/" /etc/postfix/saslauthd.conf
else
	echo "LDAP_USER_FIELD Required"
fi

# Set Postfix conf: virtual_mailbox_domains (ex: example.org)
if [ -n "$DOMAIN" ]; then
	sed -i "s/^virtual_mailbox_domains\s*=.*$/virtual_mailbox_domains = $DOMAIN/" /etc/postfix/main.cf
else
	echo "DOMAIN Required"
fi

# Set Postfix conf: hostname (ex: smtp.example.org)
if [ -n "$HOSTNAME" ]; then
	sed -i "s/^myhostname\s*=.*$/myhostname = $HOSTNAME/" /etc/postfix/main.cf
else
	echo "HOSTNAME Required"
fi

# Set Postfix conf: virtual_transport (ex: lmtp:inet:dovecot:24)
if [ -n "$LMTP_TRANSPORT" ]; then
	sed -i "s/^virtual_transport\s*=.*$/virtual_transport = $LMTP_TRANSPORT/" /etc/postfix/main.cf
else
	echo "LMTP_TRANSPORT Required"
fi

# Set Postfix conf: smtpd_tls_key_file (ex: /etc/ssl/localcerts/smtp.key.pem)
if [ -n "$SSL_KEY_PATH" ]; then
	sed -i "s#^smtpd_tls_key_file\s*=.*\$#smtpd_tls_key_file = $SSL_KEY_PATH#" /etc/postfix/main.cf
else
	echo "SSL_KEY_PATH Required"
fi

# Set Postfix conf: smtpd_tls_key_file (ex: /etc/ssl/localcerts/smtp.cert.pem)
if [ -n "$SSL_CERT_PATH" ]; then
	sed -i "s#^smtpd_tls_cert_file\s*=.*\$#smtpd_tls_cert_file = $SSL_CERT_PATH#" /etc/postfix/main.cf
else
	echo "SSL_CERT_PATH Required"
fi


# Configure DKIM
if [ -n "$DOMAIN" ]; then
	sed -i "s/^Domain\s.*$/Domain $DOMAIN/" /etc/opendkim.conf
else
	echo "DOMAIN Required"
fi

if [ -n "$DKIM_SELECTOR" ]; then
	sed -i "s/^Selector\s.*$/Selector $DKIM_SELECTOR/" /etc/opendkim.conf
else
	echo "DKIM_SELECTOR Required"
fi

if [ -n "$DKIM_KEY_PATH" ]; then
	sed -i "s|^KeyFile\s.*$|KeyFile $DKIM_KEY_PATH|" /etc/opendkim.conf
else
	echo "DKIM_KEY_PATH Required"
fi

# Generate a DKIM key if there is no DKIM key file
if [ ! -f $DKIM_KEY_PATH ]; then
	opendkim-genkey -d $DOMAIN -b 2048 -s $DKIM_SELECTOR
	mv $DKIM_SELECTOR.private $DKIM_KEY_PATH
	chmod 400 $DKIM_KEY_PATH
	mv $DKIM_SELECTOR.txt $DKIM_KEY_PATH.txt
fi


#########################################
# Generate SSL certification
#########################################

CERT_FOLDER="/etc/ssl/localcerts"
CSR_PATH="/tmp/smtp.csr.pem"

if [ -n "$SSL_KEY_PATH" ]; then
    KEY_PATH=$SSL_KEY_PATH
else
    KEY_PATH="$CERT_FOLDER/smtp.key.pem"
fi

if [ -n "$SSL_CERT_PATH" ]; then
    CERT_PATH=$SSL_CERT_PATH
else
    CERT_PATH="$CERT_FOLDER/smtp.cert.pem"
fi

# Generate self signed certificate
if [ ! -f $CERT_PATH ] || [ ! -f $KEY_PATH ]; then
    mkdir -p $CERT_FOLDER
    echo "SSL Key or certificate not found. Generating self-signed certificates"
    openssl genrsa -out $KEY_PATH
    openssl req -new -key $KEY_PATH -out $CSR_PATH \
    -subj "/CN=smtp"
    openssl x509 -req -days 3650 -in $CSR_PATH -signkey $KEY_PATH -out $CERT_PATH
fi


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
