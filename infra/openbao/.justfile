deploy:
	helm upgrade -i openbao . -n openbao

remove:
	helm uninstall openbao -n openbao
