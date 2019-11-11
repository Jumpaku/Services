#!/bin/sh

COMMAND=$1
echo ${COMMAND}

if [ ${COMMAND} = "init" ] ; then
    ./init.sh
elif [ ${COMMAND} = "modify" ] ; then
    ./modify.sh
elif [ ${COMMAND} = "display" ] ; then
    ./display.sh
elif [ ${COMMAND} = "hash" ] ; then
    cat | xargs slappasswd -s
elif [ ${COMMAND} = "ash" ] ; then
    ash
else
    echo "invalid command: ${COMMAND}"
fi