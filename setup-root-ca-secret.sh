# Ermitteln Sie den absoluten Pfad der Zertifikatsdateien
CERT_CRT_PATH=$(realpath ~/.kindpro/.ssl/ca.pem)
CERT_KEY_PATH=$(realpath ~/.kindpro/.ssl/ca.key)

# Erstellen Sie den Namespace für Cert-Manager
NAMESPACE="cert-manager"
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

# Erstellen Sie das Secret mit absoluten Pfaden
# kubectl create secret generic ca-secret --namespace cert-manager --from-file=tls.crt=$CERT_CRT_PATH --from-file=tls.key=$CERT_KEY_PATH
kubectl create secret generic root-ca-secret --namespace $NAMESPACE --from-file=tls.crt=$CERT_CRT_PATH --from-file=tls.key=$CERT_KEY_PATH --dry-run=client -o yaml | kubectl apply -f -
