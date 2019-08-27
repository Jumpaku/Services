#!/bin/bash

GITEA_DB_TYPE="SQLite3"
if [ "$DB_TYPE" = "postgres" ]; then
  GITEA_DB_TYPE="PostgreSQL"
fi
if [ "$DB_TYPE" = "mysql" ]; then
  GITEA_DB_TYPE="MySQL"
fi
if [ "$DB_TYPE" = "mssql" ]; then
  GITEA_DB_TYPE="MSSQL"
fi

# Setup form
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
\
--data "db_type=${GITEA_DB_TYPE}" \
--data "db_host=${DB_HOST}" \
--data "db_user=${DB_USER}" \
--data "db_passwd=${DB_PASSWD}" \
--data "db_name=${DB_NAME}" \
\
--data "ssl_mode=disable" \
--data "charset=utf8" \
--data "db_path=/data/gitea/gitea.db" \
\
--data "app_name=Gitea" \
--data "repo_root_path=/data/git/repositories" \
--data "lfs_root_path=/data/git/lfs" \
--data "run_user=git" \
--data "domain=${APP_DOMAIN}" \
--data "ssh_port=22" \
--data "http_port=${HTTP_PORT}" \
--data "app_url=https://${APP_DOMAIN}/" \
--data "log_root_path=/data/gitea/log" \
\
--data "smtp_host=" \
--data "smtp_from=" \
--data "smtp_user=" \
--data "smtp_passwd=" \
--data "register_confirm=off" \
--data "mail_notify=off" \
\
--data "offline_mode=off" \
--data "disable_gravatar=off" \
--data "enable_federated_avatar=off" \
--data "enable_open_id_sign_in=off" \
--data "disable_registration=on" \
--data "allow_only_external_registration=on" \
--data "enable_open_id_sign_up=off" \
--data "enable_captcha=off" \
--data "require_sign_in_view=off" \
--data "default_keep_email_private=on" \
--data "default_allow_create_organization=on" \
--data "default_enable_timetracking=on" \
--data "no_reply_address=noreply.${APP_DOMAIN}" \
\
--data "admin_name=${GITEA_ADMIN}" \
--data "admin_passwd=${GITEA_ADMIN_PASSWORD}" \
--data "admin_confirm_passwd=${GITEA_ADMIN_PASSWORD}" \
--data "admin_email=gitea_admin@${APP_DOMAIN}" \
http://localhost:${HTTP_PORT}/install
# > /data/install.html

# LDAP Auth
/app/gitea/gitea admin auth add-ldap-simple --name auth_ldap_simple --host openldap --security-protocol unencrypted --port 389 --user-dn "uid=%s,ou=users,dc=jumpaku,dc=net" --user-filter "(uid=%s)" --email-attribute mail

GITEA_CONF_APP_INI=/data/gitea/conf/app.ini
function Append {
  SECTION="$1"
  KEY="$2"
  VALUE="$3"
  sed -i -e "/^\[$SECTION\]/a\\$KEY = $VALUE" "$GITEA_CONF_APP_INI"
}
Append "repository\.upload" "MAX_FILES" "1000"
Append "repository\.upload" "FILE_MAX_SIZE" "512"
Append "attachment" "MAX_FILES" "1000"
Append "attachment" "FILE_MAX_SIZE" "512"
