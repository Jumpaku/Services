#!/bin/sh

COMMAND=$1
echo ${COMMAND}

if [ ${COMMAND} = "init" ] ; then
    ./init.sh
elif [ ${COMMAND} = "modify" ] ; then
    ./modify.sh
elif [ ${COMMAND} = "display" ] ; then
    ./display.sh
else
    echo "invalid command: ${COMMAND}"
fi