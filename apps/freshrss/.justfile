deploy:
  helm upgrade -i freshrss . -n freshrss --create-namespace

remove:
  helm delete freshrss -n freshrss

