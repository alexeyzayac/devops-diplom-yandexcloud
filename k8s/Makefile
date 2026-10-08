# ./k8s/Makefile

-include Makefile.vars

CLUSTER-ID ?= zayac

K8S_APP_NAME ?= app-diplom
K8S_APP_NS   ?= app-diplom

.PHONY: managed_kubernetes test_helm_app-diplom up_app-diplom down_app-diplom

managed_kubernetes:
	yc managed-kubernetes cluster get-credentials --id $(CLUSTER-ID) --external --force
	kubectl get nodes -o wide

test_helm_app-diplom:
	helm lint ./app-diplom/chart \
	-n $(K8S_APP_NS) \
	-f ./app-diplom/values-image.yaml
	helm template t ./app-diplom/chart \
	-n $(K8S_APP_NS) \
	-f ./app-diplom/values-image.yaml

up_app-diplom:
	helm upgrade --install $(K8S_APP_NAME) ./app-diplom/chart \
	-n $(K8S_APP_NS) --create-namespace \
	-f ./app-diplom/values-image.yaml

down_app-diplom:
	helm uninstall $(K8S_APP_NAME) -n $(K8S_APP_NS) || true
	kubectl delete namespace $(K8S_APP_NS) --ignore-not-found