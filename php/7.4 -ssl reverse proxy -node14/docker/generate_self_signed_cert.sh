#!/bin/bash

# Set variables
DOMAIN="localhost"
CERT_DIR="./certs"
PRIVATE_KEY="$CERT_DIR/$DOMAIN.key"
CSR="$CERT_DIR/$DOMAIN.csr"
CERTIFICATE="$CERT_DIR/$DOMAIN.crt"
CONFIG_FILE="$CERT_DIR/openssl.cnf"

# Create directory for certificates
mkdir -p $CERT_DIR

# Generate OpenSSL config file with Subject Alternative Name (SAN)
cat > $CONFIG_FILE <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
C = US
ST = Localhost
L = Localhost
O = MyCompany
OU = IT
CN = $DOMAIN

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = 127.0.0.1
EOF

# Generate private key
openssl genpkey -algorithm RSA -out $PRIVATE_KEY

# Generate Certificate Signing Request (CSR)
openssl req -new -key $PRIVATE_KEY -out $CSR -config $CONFIG_FILE

# Generate self-signed certificate (valid for 1 year)
openssl x509 -req -days 365 -in $CSR -signkey $PRIVATE_KEY -out $CERTIFICATE -extensions req_ext -extfile $CONFIG_FILE

echo "Self-signed certificate generated successfully!"
echo "Private Key: $PRIVATE_KEY"
echo "Certificate: $CERTIFICATE"
