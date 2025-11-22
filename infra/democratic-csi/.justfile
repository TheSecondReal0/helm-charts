deploy api-key:
	just deploy_iscsi {{api-key}}
	just deploy_nfs {{api-key}}

deploy-iscsi api-key:
	kubectl label --overwrite namespace democratic-csi pod-security.kubernetes.io/enforce=privileged
	helm upgrade -i --create-namespace --namespace democratic-csi iscsi . --values iscsi.yaml --set httpConnection.apiKey={{api-key}}

deploy-nfs api-key:
	kubectl label --overwrite namespace democratic-csi pod-security.kubernetes.io/enforce=privileged
	helm upgrade -i --create-namespace --namespace democratic-csi nfs . --values nfs.yaml --set httpConnection.apiKey={{api-key}}

remove:
	just remove_iscsi
	just remove_nfs

remove-iscsi:
	helm uninstall -n democratic-csi iscsi

remove-nfs:
	helm uninstall -n democratic-csi nfs

test-iscsi:
	kubectl apply -f pvc-iscsi.yaml

test-nfs:
	kubectl apply -f pvc-nfs.yaml

test-cleanup-iscsi:
	kubectl delete -f pvc-iscsi.yaml

test-cleanup-nfs:
	kubectl delete -f pvc-nfs.yaml

