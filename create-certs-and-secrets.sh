#!/bin/bash


# Load variables
source variables.sh

# Set up variables
CERT_DIR="certifications"
CA_CERT_FILE="$CERT_DIR/server-ca.crt"
CA_KEY_FILE="$CERT_DIR/server-ca.key"
SERVER_CERT_FILE="$CERT_DIR/server.crt"
SERVER_KEY_FILE="$CERT_DIR/server.key"
CA_SECRET_NAME="my-postgresql-server-ca"
SERVER_SECRET_NAME="my-postgresql-server"


# Create the certifications directory
mkdir -p $CERT_DIR

# Generate a private key for the CA
openssl genrsa -out $CA_KEY_FILE 2048

# Generate a self-signed CA certificate
openssl req -x509 -new -nodes -key $CA_KEY_FILE -sha256 -days 365 -out $CA_CERT_FILE \
  -subj "/CN=my-postgresql-ca"

# Generate a private key for the server
openssl genrsa -out $SERVER_KEY_FILE 2048

# Generate a certificate signing request (CSR) for the server
openssl req -new -key $SERVER_KEY_FILE -out server.csr \
  -subj "/CN=my-postgresql-server"

# Generate a server certificate signed by the CA
openssl x509 -req -in server.csr -CA $CA_CERT_FILE -CAkey $CA_KEY_FILE -CAcreateserial \
  -out $SERVER_CERT_FILE -days 365 -sha256

# Clean up the CSR file
rm server.csr

# Create the Kubernetes secrets
kubectl create secret generic $CA_SECRET_NAME --from-file=ca.crt=$CA_CERT_FILE --namespace $NS_CLUSTER
kubectl create secret tls $SERVER_SECRET_NAME --cert=$SERVER_CERT_FILE --key=$SERVER_KEY_FILE --namespace $NS_CLUSTER

# Display a message
echo "Certificates and secrets created successfully."
sleep 1
kubectl get secrets -n $NS_CLUSTER
