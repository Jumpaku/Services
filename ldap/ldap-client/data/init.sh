#!/bin/sh

ldapadd -x -h openldap -D "cn=admin,${LDAP_SUFFIX}" -w ${LDAP_ROOT_PW} -f rootdn.ldif

