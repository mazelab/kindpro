# Erstellen Sie das Verzeichnis
mkdir -p ~/.kindpro/.ssl

# Root CA private key
openssl genrsa -out ~/.kindpro/.ssl/ca.key 4096
# Root CA Certificate
openssl req -x509 -new -nodes -key ~/.kindpro/.ssl/ca.key -sha256 -days 1024 -out ~/.kindpro/.ssl/ca.pem -subj "/CN=my-root-ca"

# API Server private Key
openssl genrsa -out ~/.kindpro/.ssl/apiserver.key 2048
# API Server certificate
openssl req -new -key ~/.kindpro/.ssl/apiserver.key -out ~/.kindpro/.ssl/apiserver.csr -subj "/CN=kubernetes"
openssl x509 -req -in ~/.kindpro/.ssl/apiserver.csr -CA ~/.kindpro/.ssl/ca.pem -CAkey ~/.kindpro/.ssl/ca.key -CAcreateserial -out ~/.kindpro/.ssl/apiserver.crt -days 365 -sha256

# Front-Proxy Server private Key
openssl genrsa -out ~/.kindpro/.ssl/front-proxy-ca.key 2048
# Front-Proxy Server certificate
openssl req -new -key ~/.kindpro/.ssl/front-proxy-ca.key -out ~/.kindpro/.ssl/front-proxy-ca.csr -subj "/CN=kubernetes"
openssl x509 -req -in ~/.kindpro/.ssl/front-proxy-ca.csr -CA ~/.kindpro/.ssl/ca.pem -CAkey ~/.kindpro/.ssl/ca.key -CAcreateserial -out ~/.kindpro/.ssl/front-proxy-ca.crt -days 365 -sha256 -extensions v3_ca -extfile ./froont-proxy-ca-openssl.cnf
