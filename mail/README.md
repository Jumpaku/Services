# Mail

### MX

```
mail.jumpaku.net.
```

### SPF

```
"v=spf1 a mx -all"
```

### DKIM

```sh
docker-compose exec postfix cat /etc/dkimkeys/default.private.txt
```

```
default._domainkey      IN      TXT     ( "v=DKIM1; h=sha256; k=rsa; "
          "p=MIIBIjANBgkq ... zwN3sQIDAQAB" )  ; ----- DKIM key default for jumpaku.net
```

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
#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
#home_mailbox = Maildir/

# Dovecot SASL
smtpd_sasl_type = dovecot
smtpd_sasl_path = inet:dovecot:12345
smtpd_sasl_auth_enable = yes
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination

# LDAP
virtual_transport = lmtp:inet:dovecot:24
#virtual_mailbox_domains = jumpaku.net
virtual_mailbox_domains = localhost
virtual_mailbox_base = /var/mail
virtual_mailbox_maps = ldap:/etc/postfix/ldapvirtual

# DKIM
smtpd_milters = inet:localhost:12301
non_smtpd_milters = inet:localhost:12301
```

### /etc/postfix/master.cf

```
smtp
submission
smtps
#local
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

```sh
docker-compose run mail_test ash
```

* uid : jumpaku
* mail : jumpaku@jumpaku.net
* password : user_password

### SMTP, SMTPS and Submission

```sh
printf "testuser\0testuser\0user_password" | base64
# dGVzdHVzZXIAdGVzdHVzZXIAdXNlcl9wYXNzd29yZA==
```


```sh
telnet postfix:25
# 220 localhost ESMTP Postfix
EHLO postfix
# 250-localhost
# ...
MAIL FROM:jumpaku@jumpaku.net
# 250 2.1.0 Ok
RCPT TO:jumpaku@jumpaku.net
DATA
From: jumpaku@jumpaku.net
Subject: Mail Test

Body of test mail
.
QUIT
```

```sh
openssl s_client -connect postfix:587 -starttls smtp -ign_eof -crlf
# 220 localhost ESMTP Postfix
EHLO postfix
# 250-localhost
# ...
AUTH PLAIN dGVzdHVzZXIAdGVzdHVzZXIAdXNlcl9wYXNzd29yZA==
# 235 2.7.0 Authentication successful
MAIL FROM:<testuser@jumpaku.net>
# 250 2.1.0 Ok
RCPT TO:<testuser@jumpaku.net>
DATA
From: jumpaku@jumpaku.net
Subject: Mail Test

Body of test mail
.
QUIT
```

```sh
openssl s_client -connect postfix:465 -ign_eof -crlf
# 220 localhost ESMTP Postfix
EHLO postfix
# 250-localhost
# ...
AUTH PLAIN dGVzdHVzZXIAdGVzdHVzZXIAdXNlcl9wYXNzd29yZA==
# 235 2.7.0 Authentication successful
MAIL FROM:<testuser@jumpaku.net>
# 250 2.1.0 Ok
RCPT TO:<testuser@jumpaku.net>
# 250 2.1.5 Ok
DATA
From:jumpaku@localhost
To:jumpaku@localhost
Subject: Mail Test

Body of test mail

.
# 250 2.0.0 Ok: queued as ...
QUIT
# 221 2.0.0 Bye
```

### IMAP and IMAPS

```sh
telnet dovecot 143
a LOGIN testuser user_password
b LIST "" *
c SELECT INBOX
d FETCH 1 body[]
e LOGOUT
```

```sh
openssl s_client -connect dovecot:993
# * OK...
a LOGIN testuser user_password
# a OK ... Logged in
b LIST "" *
c SELECT INBOX
e LOGOUT
# * BYE Logging out
# e OK Logout completed ...
```