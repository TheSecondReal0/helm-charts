deploy:
  helm upgrade -i traefik . -f values.yaml -n traefik --create-namespace

gateway:
  kubectl apply -f gateway.yaml -n traefik

whoami:
  kubectl apply -f whoami.yaml -n traefik

remove:
  helm delete traefik -n traefik

