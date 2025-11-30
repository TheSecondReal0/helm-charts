deploy:
  helm upgrade -i whoami . -n whoami --create-namespace

remove:
  helm uninstall whoami -n whoami

