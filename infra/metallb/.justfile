deploy:
  kubectl apply -f namespace.yaml
  helm upgrade -i metallb . -n metallb -f values.yaml
  kubectl apply -f ipaddresspool.yaml

remove:
  helm uninstall metallb -n metallb

