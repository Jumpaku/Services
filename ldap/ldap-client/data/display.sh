#!/bin/sh

ldapsearch -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w secret_password -b "dc=jumpaku,dc=net" "(objectClass=*)"

