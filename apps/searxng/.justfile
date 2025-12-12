deploy:
  helm upgrade -i searxng . -n searxng --create-namespace

remove:
  helm delete searxng -n searxng

