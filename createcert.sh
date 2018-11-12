#!/bin/bash

check_ret () {
  if [ $? -ne "0" ]
    then
      echo "$1 failed"
  fi
}

country="US"
state="CA"
city="SJ"
cn="front-end-vip-fqdn.com"
orgname="Philips"


ca_cert_pem () {

  openssl genrsa 2048 > ca.key
  check_ret "ssl keygen creation "

  #openssl req -new -x509 -nodes -days 3600 -key ca-key.pem -out ca.pem -subj "/C=$country/ST=$state/L=$city/O=$orgname/CN=$cn"
  openssl req -new -key ca.key -out cert.csr -subj "/C=$country/ST=$state/L=$city/O=$orgname/CN=$cn"
  check_ret "CA cert pem creation "
}

server_cert_pem () {
  #openssl req -newkey rsa:2048 -days 3600 -nodes -subj "/C=$country/ST=$state/L=$city/O=$orgname/CN=$cn" -keyout server-key.pem -out server-req.pem
  openssl x509 -req -days 365 -in cert.csr -signkey ca.key -out ca.crt
  check_ret "server side req creation "

  #openssl rsa -in server-key.pem -out server-key.pem
  #check_ret "server side key creation "

  #openssl x509 -req -in server-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
  #check_ret "server side certificate creation "
}

create_pem () {
  cat ca.crt ca.key | tee crt.pem
  check_ret "pem file "
}


copy_files () {
  cp ca.crt /etc/ssl/
  check_ret "copy ca.pem "

  cp ca.key /etc/ssl/
  check_ret "copy server-cert.pem "

  cp cert.csr /etc/ssl/
  check_ret "copy server key.pem "

  cp crt.pem /etc/ssl/
  check_ret "copy server key.pem "
}

ca_cert_pem
server_cert_pem
create_pem
copy_files
