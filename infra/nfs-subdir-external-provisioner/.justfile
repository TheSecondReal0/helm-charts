deploy:
	kubectl label --overwrite namespace nfs-subdir-external-provisioner pod-security.kubernetes.io/enforce=privileged
	helm upgrade -i nfs-subdir-external-provisioner . -n nfs-subdir-external-provisioner --create-namespace

remove:
	helm uninstall nfs-subdir-external-provisioner -n nfs-subdir-external-provisioner

