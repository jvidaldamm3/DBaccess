#!/bin/bash

# Variables
DAYS=1095
CA_KEY="ca-key.pem"
CA_CERT="ca-cert.pem"
SERVER_KEY="server-key.pem"
SERVER_CERT="server-cert.pem"
CLIENT_KEY="client-key.pem"
CLIENT_CERT="client-cert.pem"

# Create CA
openssl genpkey -algorithm RSA -out $CA_KEY -aes256
openssl req -new -x509 -days $DAYS -key $CA_KEY -out $CA_CERT

# Create Server Certificate
openssl genpkey -algorithm RSA -out $SERVER_KEY
openssl req -new -key $SERVER_KEY -out server-req.pem
openssl x509 -req -in server-req.pem -days $DAYS -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $SERVER_CERT

# Create Client Certificate
openssl genpkey -algorithm RSA -out $CLIENT_KEY
openssl req -new -key $CLIENT_KEY -out client-req.pem
openssl x509 -req -in client-req.pem -days $DAYS -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $CLIENT_CERT

# Clean up
rm server-req.pem client-req.pem

echo "Certificates generated successfully."