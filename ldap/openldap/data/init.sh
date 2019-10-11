#!/bin/sh

SLAPD_CONF=/etc/openldap/slapd.conf
cp /home/openldap/slapd.conf ${SLAPD_CONF}

LDAP_SUFFIX="dc=jumpaku,dc=net"
LDAP_ROOT_DN="cn=admin,${LDAP_SUFFIX}"
HASHED_LDAP_ROOT_PW=`slappasswd -s ${LDAP_ROOT_PW}`

echo "Configure ${SLAPD_CONF}"

sed -i "s/^suffix.*$/suffix\t\t${LDAP_SUFFIX}/" ${SLAPD_CONF}
sed -i "s/^rootdn.*$/rootdn\t\t${LDAP_ROOT_DN}/" ${SLAPD_CONF}
sed -i "s|^rootpw.*$|rootpw\t\t${HASHED_LDAP_ROOT_PW}|" ${SLAPD_CONF}

slapd -h "ldap://openldap" -d 256
