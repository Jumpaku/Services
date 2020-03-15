#!/bin/sh

# start.sh < domains.txt
# start.sh local < domains.txt
# start.sh staging < domains.txt
# start.sh production < domains.txt
# start.sh certs < domains.txt
# start.sh certs local < domains.txt
# start.sh certs staging < domains.txt
# start.sh certs production < domains.txt

if [ "$1" = "certs" ]; then
    DOMAINS=`cat | awk '{ print $1 }' | xargs printf "%s, "`
    if [ "$2" = "production" -o "$2" = "staging" ]; then
        STAGE="$2"
    else
        STAGE="local"
    fi
else
    DOMAINS=`cat | python -c "import sys; print (', '.join([l.rstrip('\r\n') for l in sys.stdin.readlines()]))"`
    if [ "$1" = "production" -o "$1" = "staging" ]; then
        STAGE="$1"
    else
        STAGE="local"
    fi
fi

echo "DOMAINS=${DOMAINS}"
echo "STAGE=${STAGE}"

REVERSE_PROXY_ENV="reverse_proxy.env"
echo "" > ${REVERSE_PROXY_ENV}
echo "CLIENT_MAX_BODY_SIZE=512M" >> ${REVERSE_PROXY_ENV}
echo "DOMAINS=${DOMAINS}" >> ${REVERSE_PROXY_ENV}
echo "STAGE=${STAGE}" >> ${REVERSE_PROXY_ENV}

if [ "$1" = "certs" ]; then
    docker-compose up
else
    docker-compose up -d
fi
