#!/bin/sh

ldapsearch -c -x -h openldap -D "cn=admin,${LDAP_SUFFIX}" -w ${LDAP_ROOT_PW} -b "ou=users,${LDAP_SUFFIX}" "(&(objectClass=inetOrgPerson)(uid=*))" \
    |sed -e "s/\s//" \
    |grep "^dn:uid=.*,ou=users,${LDAP_SUFFIX}$" \
    |sed "s/^dn://" \
    |ldapdelete -x -h openldap -D "cn=admin,${LDAP_SUFFIX}" -w ${LDAP_ROOT_PW}

# Get content of ldif from standard input
mkdir tmp
USERS_LDIF=/home/data/tmp/users.ldif
cat > ${USERS_LDIF}
ldapadd -c -x -h openldap -D "cn=admin,${LDAP_SUFFIX}" -w ${LDAP_ROOT_PW} -f ${USERS_LDIF}
rm ${USERS_LDIF}
