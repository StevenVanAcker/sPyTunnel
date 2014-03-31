#!/bin/bash

function makeKeyAndCSR() {
    countryCode=SE
    state=Gota
    city=Gothenburg
    company=OverTheWire
    organizationalUnitName=warzone
    email=admin@overthewire.org
    fnprefix="$1"
    bits=$2
    domain="$3"

    openssl req -nodes -newkey rsa:$bits -keyout "$fnprefix.key" -out "$fnprefix.csr" \
	-batch -subj "/C=$countryCode/ST=$state/L=$city/O=$company/OU=$organizationalUnitName/CN=$domain/emailAddress=$email"
}

makeKeyAndCSR "ca"		4096 "test-ca"
makeKeyAndCSR "testserver" 	1024 "testserver"
makeKeyAndCSR "testclient" 	1024 "testclient"

# self sign CA certificate
openssl req -x509 -days 365 -in ca.csr -key ca.key  -out ca.crt
# sign server and client cert
openssl x509 -req -days 365 -in testserver.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out testserver.crt
openssl x509 -req -days 365 -in testclient.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out testclient.crt

chmod go= *.key
