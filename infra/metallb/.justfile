deploy:
  kubectl apply -f namespace.yaml
  kubectl apply -f ipaddresspool.yaml
  helm upgrade -i metallb . -n metallb -f values.yaml

remove:
  helm uninstall metallb -n metallb

