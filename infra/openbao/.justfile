deploy:
	helm upgrade -i openbao . -n openbao --create-namespace

remove:
	helm uninstall openbao -n openbao
