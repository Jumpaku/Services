#!/bin/sh

ldapsearch -x -h openldap -D "cn=admin,${LDAP_SUFFIX}" -w ${LDAP_ROOT_PW} -b "${LDAP_SUFFIX}" "(objectClass=*)"

