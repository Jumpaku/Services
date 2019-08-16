# Mail

## Postfix

```ini
mail_owner = postfix
#myhostname = mail.jumpaku.net
myhostname = localhost
#mydomain = jumpaku.net
mydomain = localhost
myorigin = $mydomain
inet_interfaces = all
inet_protocols = ipv4
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
home_mailbox = Maildir/

# Dovecot SASL
smtpd_sasl_type = dovecot
smtpd_sasl_path = inet:dovecot:12345
smtpd_sasl_auth_enable = yes
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination

# LDAP
virtual_transport = virtual
virtual_mailbox_domains = localhost
#virtual_mailbox_domains = jumpaku.net
virtual_mailbox_base = /var/mail
virtual_mailbox_maps = ldap:/etc/postfix/ldapvirtual
```

## Dovecot

### /etc/dovecot/conf.d/10-mail.conf

```ini
mail_home = /var/vmail/%n
mail_location = maildir:~/mail
mail_uid = 1000
mail_gid = 1000
```
### /etc/dovecot/conf.d/10-ssl.conf

```conf
ssl = yes
#ssl_prefer_server_ciphers = yes
```

### /etc/dovecot/conf.d/10-auth.conf

```ini
disable_plaintext_auth = no
auth_mechanisms = plain login
#!include auth-passwdfile.conf.ext
!include auth-ldap.conf.ext
```

### /etc/dovecot/dovecot-ldap.conf.ext

```conf
hosts = openldap
auth_bind = no
ldap_version = 3
base = ou=users,dc=jumpaku,dc=net
user_attrs = uid=user
user_filter = (uid=%u)
pass_attrs = uid=user,userPassword=password
pass_filter = (uid=%u)
```

### /etc/dovecot/conf.d/10-master.conf

```conf
service imap-login
#service pop3-login
service submission-login
service lmtp

service auth {
 inet_listener {
   port = 12345
 }
}
```

## Auth Test

### IMAP and IMAPS

```sh
docker-compose run mail_test ash
```

```sh
telnet dovecot 143
# OK...
a LOGIN jumpaku user_password
# a OK ... Logged in
a LOGOUT
```

```sh
openssl s_client dovecot:993
# OK...
a LOGIN jumpaku user_password
# a OK ... Logged in
a LOGOUT
```