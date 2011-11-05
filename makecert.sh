#!/bin/bash
#
# Script to generate self signed certificates for use
# with Apache2 based web servers.

BIN="/usr/bin/openssl"

DEF_USER="John Average Doe"
DEF_MAIL="user@domain.tld"
DEF_ORG="Acme Networks"
DEF_DOMAIN="sub.domain.tld"
DEF_COUNTRY="NO"
DEF_STATE="State"
DEF_LOCATION="Country"

DEBUG=0

echo -e "\033[1mChecking for openssl binary\033[0m"
if [ ! -f "$BIN" ]; then
    echo "WARNING! openssl binary not found... WARNING!"
    exit 1
fi

echo -e "\033[1mEnter administrative name (ie: John Doe)\033[0m"
read -e USER
if [ -z "$USER" ]; then
    echo "No name entered, using default ($DEF_USER)"
    USER="$DEF_USER"
fi

echo -e "\033[1mEnter adminstrative e-mail address (ie: user@domain.tld)\033[0m"
read -e EMAIL
if [ -z "$EMAIL" ]; then
    echo "No e-mail address entered, using default ($DEF_MAIL)"
    EMAIL="$DEF_MAIL"
fi

echo -e "\033[1mEnter organization name (ie: Acme Networks Ltd)\033[0m"
read -e ORG
if [ -z "$ORG" ]; then
    echo "No organization entered, using default ($DEF_ORG)"
    ORG="$DEF_ORG"
fi

echo -e "\033[1mEnter domain name (ie: sub.domain.tld)\033[0m"
read -e DOMAIN
if [ -z "$DOMAIN" ]; then
    echo "No domain entered, using default ($DEF_DOMAIN)"
    DOMAIN="$DEF_DOMAIN"
fi

echo -e "\033[1mEnter country (ie: US)\033[0m"
read -e COUNTRY
if [ -z "$COUNTRY" ]; then
    echo "No country entered, using default ($DEF_COUNTRY)"
    COUNTRY="$DEF_COUNTRY"
fi

echo -e "\033[1mEnter state/city (ie: New York)\033[0m"
read -e STATE
if [ -z "$STATE" ]; then
    echo "No state entered, using default ($DEF_STATE)"
    STATE="$DEF_STATE"
fi

echo -e "\033[1mEnter location (ie: Manhatten)\033[0m"
read -e LOCATION
if [ -z "$LOCATION" ]; then
    echo "No location entered, using default ($DEF_LOCATION)"
    LOCATION="$DEF_LOCATION"
fi

OPTS=(/C="$COUNTRY"/ST="$STATE"/L="$LOCATION"/O="$ORG"/OU="$DOMAIN"/CN="$USER"/emailAddress="$EMAIL")

if [ $DEBUG ] ; then
    echo "${OPTS[@]}"
fi

COMMAND=($BIN req -new -x509 -nodes -days 365 -subj "${OPTS[@]}" -newkey rsa:1024 -keyout $DOMAIN.key -out $DOMAIN.cert)

if [ $DEBUG ] ; then
    echo "Running ${COMMAND[@]}"
fi

"${COMMAND[@]}"
if (( $? )) ; then
    echo -e "ERROR: Something went wrong!"
    exit 1
else
   echo "Done!"
fi

exit 0
