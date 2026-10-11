# ./k8s/Makefile

-include Makefile.vars

CLUSTER-ID          ?= zayac

K8S_APP_NAME        ?= app-diplom
K8S_APP_NS          ?= app-diplom

K8S_MONITORING_NAME ?= kube-prometheus
K8S_MONITORING_NS   ?= monitoring

.PHONY: managed_kubernetes test_helm_app-diplom up_app-diplom down_app-diplom test_helm_monitoring up_monitoring down_monitoring

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

test_helm_monitoring:
	helm template $(K8S_MONITORING_NAME) prometheus-community/kube-prometheus-stack \
	  -n $(K8S_MONITORING_NS) \
	  --values monitoring/monitoring-values.yaml

up_monitoring:
	kubectl create namespace monitoring
	helm upgrade --install $(K8S_MONITORING_NAME) prometheus-community/kube-prometheus-stack \
	  --namespace $(K8S_MONITORING_NS) \
	  --values monitoring/monitoring-values.yaml \
	  --wait --timeout 15m

down_monitoring:
	helm uninstall $(K8S_MONITORING_NAME) -n $(K8S_MONITORING_NS) || true
	kubectl delete namespace $(K8S_MONITORING_NS) --ignore-not-found
