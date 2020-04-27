#!/bin/sh

# Configures .env.

function generatePassword() {
    openssl rand -hex 16
}

JICOFO_COMPONENT_SECRET=`generatePassword`
JICOFO_AUTH_PASSWORD=`generatePassword`
JVB_AUTH_PASSWORD=`generatePassword`
JIGASI_XMPP_PASSWORD=`generatePassword`
JIBRI_RECORDER_PASSWORD=`generatePassword`
JIBRI_XMPP_PASSWORD=`generatePassword`

# Directory where all configuration will be stored
CONFIG="./jitsi-meet-cfg"

# Exposed HTTP port
#HTTP_PORT=8000

# Exposed HTTPS port
#HTTPS_PORT=8443

# System time zone
TZ=Asia/Tokyo

# Public URL for the web service
PUBLIC_URL='https://jitsi-meet.jumpaku.net'

cat env.example > '.env'
sed -i.bak "s#JICOFO_COMPONENT_SECRET=.*#JICOFO_COMPONENT_SECRET=${JICOFO_COMPONENT_SECRET}#g" '.env'
sed -i.bak "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}#g" '.env'
sed -i.bak "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}#g" '.env'
sed -i.bak "s#JIGASI_XMPP_PASSWORD=.*#JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD}#g" '.env'
sed -i.bak "s#JIBRI_RECORDER_PASSWORD=.*#JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD}#g" '.env'
sed -i.bak "s#JIBRI_XMPP_PASSWORD=.*#JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD}#g" '.env'

sed -i.bak "s#CONFIG=.*#CONFIG=${CONFIG}#g" '.env'
sed -i.bak "s#TZ=.*#TZ=${TZ}#g" '.env'
sed -i.bak "s#PUBLIC_URL=.*#PUBLIC_URL=${PUBLIC_URL}#g" '.env'

rm -rf jitsi-meet-cfg/
mkdir -p jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody,jicofo,jvb}
