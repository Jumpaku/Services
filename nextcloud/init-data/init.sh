#!/bin/bash

php occ app:disable files_versions
php occ app:enable user_ldap
php occ config:system:set trusted_domains 0 --value=localhost
php occ config:system:set trusted_domains 1 --value=nextcloud
php occ config:system:set trusted_domains 2 --value="$NEXTCLOUD_DOMAIN"
php occ config:system:set overwritehost --value="$NEXTCLOUD_DOMAIN"
php occ config:system:set overwriteprotocol --value=https

CONFIG_ID="s01"
php occ ldap:delete-config "$CONFIG_ID"
php occ ldap:create-empty-config

function ConfigureLdap {
    KEY="$1"
    VALUE="$2"
    echo "$KEY : $VALUE"
    php occ ldap:set-config "$CONFIG_ID" "$KEY" "$VALUE"
}

echo "Configure LDAP"
ConfigureLdap homeFolderNamingRule 'attr:uid'
ConfigureLdap ldapAgentName "cn=app,${LDAP_SUFFIX}"
ConfigureLdap ldapAgentPassword "${LDAP_APP_PASSWORD}"
ConfigureLdap ldapExpertUsernameAttr uid
ConfigureLdap ldapBase "ou=users,${LDAP_SUFFIX}"
ConfigureLdap ldapBaseGroups "ou=users,${LDAP_SUFFIX}"
ConfigureLdap ldapBaseUsers "ou=users,${LDAP_SUFFIX}"
ConfigureLdap ldapConfigurationActive 1
ConfigureLdap ldapEmailAttribute mail
ConfigureLdap ldapHost openldap
ConfigureLdap ldapLoginFilter '(&(|(objectclass=inetOrgPerson))(|(uid=%uid)))'
ConfigureLdap ldapLoginFilterAttributes uid
ConfigureLdap ldapLoginFilterUsername 0
ConfigureLdap ldapPort 389
ConfigureLdap ldapUserDisplayName uid
ConfigureLdap ldapUserFilter '(|(objectclass=inetOrgPerson))'
ConfigureLdap ldapUserFilterObjectclass inetOrgPerson
