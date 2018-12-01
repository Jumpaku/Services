#!/bin/sh

ldap_suffix="dc=jumpaku,dc=net"
ldap_root_dn="cn=admin,${ldap_suffix}"
ldapadd -x -h openldap -D ${ldap_root_dn} -w ${LDAP_ROOT_PW} -f rootdn.ldif
