deploy:
  helm upgrade -i vikunja . -n vikunja --create-namespace

remove:
  helm uninstall vikunja -n vikunja

