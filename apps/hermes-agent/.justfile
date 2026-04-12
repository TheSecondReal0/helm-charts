deploy:
  helm upgrade -i hermes-agent . -n hermes-agent --create-namespace

remove:
  helm uninstall hermes-agent -n hermes-agent

