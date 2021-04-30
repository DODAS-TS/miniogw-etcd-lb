#!/bin/bash

mkdir -p certs
cd certs

openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=etcd-ca"

# Generate certs for etcd1
sed 's/CHANGEME_HOST/etcd1/' openssl.conf > openssl1_tmp.conf
sed 's/CHANGEME_IP/$1/' openssl1_tmp.conf > openssl1.conf
export CONFIG=`echo $PWD/openssl1.conf`

openssl genrsa -out member-etcd1-key.pem 2048
openssl req -new -key member-etcd1-key.pem -out member-etcd1.csr -subj "/CN=etcd1" -config ${CONFIG}

openssl x509 -req -in member-etcd1.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd1.pem -days 3650 -extensions ssl_client -extfile ${CONFIG}

# Generate certs for etcd2
sed 's/CHANGEME_HOST/etcd2/' openssl.conf > openssl2_tmp.conf
sed 's/CHANGEME_IP/$2/' openssl2_tmp.conf > openssl2.conf
export CONFIG=`echo $PWD/openssl2.conf`


openssl genrsa -out member-etcd2-key.pem 2048
openssl req -new -key member-etcd2-key.pem -out member-etcd2.csr -subj "/CN=etcd2" -config ${CONFIG}

openssl x509 -req -in member-etcd2.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd2.pem -days 3650 -extensions ssl_client -extfile ${CONFIG}

# Generate certs for etcd3
sed 's/CHANGEME_HOST/etcd3/' openssl.conf > openssl3_tmp.conf
sed 's/CHANGEME_IP/$3/' openssl3_tmp.conf > openssl3.conf
export CONFIG=`echo $PWD/openssl3.conf`


openssl genrsa -out member-etcd3-key.pem 2048
openssl req -new -key member-etcd3-key.pem -out member-etcd3.csr -subj "/CN=etcd3" -config ${CONFIG}

openssl x509 -req -in member-etcd3.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd3.pem -days 3650 -extensions ssl_client -extfile ${CONFIG}
