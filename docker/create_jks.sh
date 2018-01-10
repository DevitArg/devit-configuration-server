#!/bin/bash

# USAGE ./create_jks --alias keyalias --keystorename server --storepass YbGf69YUKLnN --validity 365

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --alias)
    ALIAS="$2"
    shift # past argument
    shift # past value
    ;;
    --keystorename)
    KEYSTORE_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    --storepass)
    STOREPASS="$2"
    shift # past argument
    shift # past value
    ;;
    --validity)
    VALIDITY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Parameters are ..."
echo ALIAS="${ALIAS}"
echo KEYSTORE_NAME="${KEYSTORE_NAME}"
echo STOREPASS="${STOREPASS}"
echo VALIDITY="${VALIDITY}"

if [[ -n $ALIAS && -n $KEYSTORE_NAME && -n $STOREPASS && -n $VALIDITY ]]
then
    echo "Generating a key pair jks file...."
    keytool -genkeypair -keyalg RSA \
      -dname "CN=Web Server,OU=Unit,O=Organization,L=City,S=State,C=US" \
      -alias ${ALIAS} \
      -keystore ${KEYSTORE_NAME}.jks -storepass ${STOREPASS} \
      -validity ${VALIDITY}

    if [[ $? -eq 0 ]]
    then
      echo "Created key ${KEYSTORE_NAME}.jks"
      exit 0
    else
      echo "The script failed" >&2
      exit 1
    fi
else
    echo "The script has failed because you have not passed some required value/s"
    exit 2
fi