# ./k8s/Makefile

-include Makefile.vars	

CLUSTER-ID ?= zayac

K8S_APP_NAME ?= app-diplom
K8S_APP_NS   ?= app-diplom

.PHONY: managed_kubernetes up_app down_app

managed_kubernetes:
	yc managed-kubernetes cluster get-credentials --id $(CLUSTER-ID) --external --force
	kubectl get nodes -o wide

up_app-diplom:
	helm upgrade --install $(K8S_APP_NAME) ./app-diplom/chart \
	-n $(K8S_APP_NS) --create-namespace \
	-f ./app-diplom/chart/values.yaml

down_app-diplom:
	helm uninstall $(K8S_APP_NAME) -n $(K8S_APP_NS) || true
	kubectl delete namespace $(K8S_APP_NS) --ignore-not-found