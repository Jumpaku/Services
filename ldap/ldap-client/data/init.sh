#!/bin/sh

ldapadd -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w ${LDAP_ROOT_PW} -f rootdn.ldif

