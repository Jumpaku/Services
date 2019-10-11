#!/bin/sh

ldapsearch -c -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w ${LDAP_ROOT_PW} -b "ou=users,dc=jumpaku,dc=net" "(&(objectClass=inetOrgPerson)(uid=*))" \
    |sed -e 's/\s//' \
    |grep '^dn:uid=.*,ou=users,dc=jumpaku,dc=net$' \
    |sed 's/^dn://' \
    |ldapdelete -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w ${LDAP_ROOT_PW}
ldapadd -c -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w ${LDAP_ROOT_PW} -f users.ldif
