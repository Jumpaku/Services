#!/bin/bash

php occ app:disable files_versions
php occ app:enable user_ldap

CONFIG_ID="s01"
php occ ldap:delete-config "$CONFIG_ID"
php occ ldap:create-empty-config

function ConfigureLdap {
    KEY="$1"
    VALUE="$2"
    MESSAGE="$3"
    php occ ldap:set-config "$CONFIG_ID" "$KEY" "$VALUE"
    echo "Configure: $MESSAGE"
}

ConfigureLdap ldapBase ou=users,dc=jumpaku,dc=net "ldapBase"
ConfigureLdap ldapBaseGroups ou=users,dc=jumpaku,dc=net "ldapBaseGroups"
ConfigureLdap ldapBaseUsers ou=users,dc=jumpaku,dc=net "ldapBaseUsers"
ConfigureLdap ldapConfigurationActive 1 "ldapConfigurationActive"
ConfigureLdap ldapEmailAttribute mail "ldapEmailAttribute"
ConfigureLdap ldapHost openldap "ldapHost"
ConfigureLdap ldapLoginFilter '(&(|(objectclass=inetOrgPerson))(|(uid=%uid)))' "ldapLoginFilter"
ConfigureLdap ldapLoginFilterAttributes uid "ldapLoginFilterAttributes"
ConfigureLdap ldapLoginFilterUsername 0 "ldapLoginFilterUsername"
ConfigureLdap ldapPort 389 "ldapPort"
ConfigureLdap ldapUserDisplayName uid "ldapUserDisplayName"
ConfigureLdap ldapUserFilter '(|(objectclass=inetOrgPerson))' "ldapUserFilter"
ConfigureLdap ldapUserFilterObjectclass inetOrgPerson "ldapUserFilterObjectclass"
