#!/bin/sh

SLAPD_CONF=/etc/openldap/slapd.conf
cp /home/openldap/slapd.conf ${SLAPD_CONF}

echo "Configure ${SLAPD_CONF}"

LDAP_ROOT_DN="cn=admin,${LDAP_SUFFIX}"
HASHED_LDAP_ROOT_PW=`slappasswd -s ${LDAP_ROOT_PW}`

sed -i "s/^suffix.*$/suffix\t\t${LDAP_SUFFIX}/" ${SLAPD_CONF}
sed -i "s/^rootdn.*$/rootdn\t\t${LDAP_ROOT_DN}/" ${SLAPD_CONF}
sed -i "s|^rootpw.*$|rootpw\t\t${HASHED_LDAP_ROOT_PW}|" ${SLAPD_CONF}

CERTS_DIR=/home/openldap/certs
sed -i "s|^TLSCACertificateFile.*$|TLSCACertificateFile\t${CERTS_DIR}/signed.crt|" ${SLAPD_CONF}
sed -i "s|^TLSCertificateFile.*$|TLSCertificateFile\t${CERTS_DIR}/signed.crt|" ${SLAPD_CONF}
sed -i "s|^TLSCertificateKeyFile.*$|TLSCertificateKeyFile\t${CERTS_DIR}/domain.key|" ${SLAPD_CONF}

#echo "access to attr=userPassword" by * auth" >> ${SLAPD_CONF}
echo "" >> ${SLAPD_CONF}
# * is allowed to bind.
echo "access to dn.children=\"${LDAP_SUFFIX}\" attrs=userPassword by * auth" >> ${SLAPD_CONF}
# app is allawed to read users.
echo "access to dn.subtree=\"ou=users,${LDAP_SUFFIX}\"" >> ${SLAPD_CONF}
echo "    by dn.base=\"cn=app,${LDAP_SUFFIX}\" read" >> ${SLAPD_CONF}
echo "    by self read" >> ${SLAPD_CONF}
echo "    by * none" >> ${SLAPD_CONF}

slaptest -u -f ${SLAPD_CONF}

slapd -h 'ldap:/// ldaps:///' -d 256
