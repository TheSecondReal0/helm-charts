deploy:
  helm upgrade -i grafana . -n grafana --create-namespace

remove:
  helm delete grafana -n grafana

