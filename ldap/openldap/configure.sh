#!/bin/sh

ldap_suffix="dc=jumpaku,dc=net"
ldap_root_dn="cn=admin,${ldap_suffix}"

#hashed_password=`slappasswd -s ${LDAP_ROOT_PW}`
config_file=/home/openldap/slapd.conf

sed -i "s/^suffix.*$/suffix\t\t${ldap_suffix}/" ${config_file}
sed -i "s/^rootdn.*$/rootdn\t\t${ldap_root_dn}/" ${config_file}
sed -i "s/^rootpw.*$/rootpw\t\t${LDAP_ROOT_PW}/" ${config_file}

slaptest -f ${config_file} -F /etc/openldap/slapd.d || true

slapd -h "ldap://openldap" -d 256