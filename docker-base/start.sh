#!/bin/bash
echo "Starting docker container ... "

if [  $DEBUG_CONFIG ];
then
    echo "DEBUG CONFIGURATION: $DEBUG_CONFIG"
    java ${DEBUG_CONFIG} -Djava.security.egd=file:/dev/./urandom -jar /app.jar
else
    java -Djava.security.egd=file:/dev/./urandom -jar /app.jar
fi


