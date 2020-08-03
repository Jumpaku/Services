#!/bin/sh

ADMIN_PASSWORD=`docker-compose exec nexus cat /nexus-data/admin.password`
echo "admin name is:"
echo "admin"
echo "admin password is:"
echo "$ADMIN_PASSWORD"

cat <<'EOF'
-----

Setup nexus3 in browser:

1. Change admin's password.
2. Allow anonymous access.
3. Create LDAP connection and login as a connected user.
  * Name: ldap
  * LDAP server address: ldap://openldap:389
  * Serch base DN: ou=users,dc=jumpaku,dc=net
  * Authantication method: Simple Authantication
  * Username or DN: cn=app,dc=jumpaku,dc=net

  * Configuration template: none
  * User subtree: checked
  * Object class: inetOrgPerson
  * User filter: none
  * User ID attribute: uid
  * Real name attribute: uid
  * Email attribute: mail
  * Password attribute: userPassword
  * Map LDAP groups as roles: unchecked

4. Create Role with Privilege as follows and Role to the user.

  * nx-component-upload
  * nx-repository-view-*-*-*

5. Create backup task with the following cron expression `* 0 0 * ? * * *` and start.

-----
EOF