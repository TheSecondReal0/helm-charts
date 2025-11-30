deploy:
  helm upgrade -i tandoor . -n tandoor --create-namespace

remove:
  helm uninstall tandoor -n tandoor

