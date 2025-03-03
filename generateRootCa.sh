# Erstellen Sie das Verzeichnis
mkdir -p ~/.kindpro/.ssl

# Root CA private key
openssl genrsa -out ~/.kindpro/.ssl/ca.key 4096
# Root CA Certificate
openssl req -x509 -new -nodes -key ~/.kindpro/.ssl/ca.key -sha256 -days 1024 -out ~/.kindpro/.ssl/ca.crt -subj "/CN=my-root-ca"
