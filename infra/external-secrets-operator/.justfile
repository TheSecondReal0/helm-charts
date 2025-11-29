deploy openbao-token:
  # might need to deploy without openbao SecretStore first, maybe could automate that
  helm upgrade -i external-secrets . -n external-secrets --create-namespace --set openbao.token=$(echo -n {{openbao-token}} | base64 -)

remove:
  helm uninstall -n external-secrets external-secrets

