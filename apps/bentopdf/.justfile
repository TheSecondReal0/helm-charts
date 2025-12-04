deploy:
  helm upgrade -i bentopdf . -n bentopdf --create-namespace

remove:
  helm delete bentopdf -n bentopdf

