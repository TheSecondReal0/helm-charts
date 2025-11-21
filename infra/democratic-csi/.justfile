deploy api-key:
	kubectl label --overwrite namespace democratic-csi pod-security.kubernetes.io/enforce=privileged
	helm upgrade -i --create-namespace --namespace democratic-csi iscsi . --values iscsi.yaml --set httpConnection.apiKey={{api-key}}

remove:
	helm uninstall -n democratic-csi iscsi

test:
	kubectl apply -f pvc-iscsi.yaml

test-cleanup:
	kubectl delete -f pvc-iscsi.yaml

