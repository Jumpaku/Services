#!/bin/bash

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
4. Create Role with Privilege

  * nx-component-upload
  * nx-repository-view-*-*-*

and Role to the user.

-----
EOF