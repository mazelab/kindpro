# Erstellen Sie das Verzeichnis
mkdir -p ~/.kindpro/.ssl

# Root CA private key
openssl genrsa -out ~/.kindpro/.ssl/root-ca.key 4096
# Root CA Certificate
openssl req -x509 -new -nodes -key ~/.kindpro/.ssl/root-ca.key -sha256 -days 1024 -out ~/.kindpro/.ssl/root-ca.pem -subj "/CN=my-root-ca"

# API Server private Key
openssl genrsa -out ~/.kindpro/.ssl/apiserver.key 2048
# API Server certificate
openssl req -new -key ~/.kindpro/.ssl/apiserver.key -out ~/.kindpro/.ssl/apiserver.csr -subj "/CN=kubernetes"
openssl x509 -req -in ~/.kindpro/.ssl/apiserver.csr -CA ~/.kindpro/.ssl/root-ca.pem -CAkey ~/.kindpro/.ssl/root-ca.key -CAcreateserial -out ~/.kindpro/.ssl/apiserver.crt -days 365 -sha256


# Ermitteln Sie den absoluten Pfad der Zertifikatsdateien
CERT_CRT_PATH=$(realpath ~/.kindpro/.ssl/root-ca.pem)
CERT_KEY_PATH=$(realpath ~/.kindpro/.ssl/root-ca.key)

# Erstellen Sie den Namespace für Cert-Manager
NAMESPACE="cert-manager"
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

# Erstellen Sie das Secret mit absoluten Pfaden
# kubectl create secret generic root-ca-secret --namespace cert-manager --from-file=tls.crt=$CERT_CRT_PATH --from-file=tls.key=$CERT_KEY_PATH
kubectl create secret generic root-ca-secret --namespace $NAMESPACE --from-file=tls.crt=$CERT_CRT_PATH --from-file=tls.key=$CERT_KEY_PATH --dry-run=client -o yaml | kubectl apply -f -
