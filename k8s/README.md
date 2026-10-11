# Создание тестового приложения

## mininkube

```bash
# Кластер кубернетесе в minikube
minikube start --kubernetes-version=v1.31.0 \
  --driver=virtualbox \
  --container-runtime=containerd \
  --addons=dashboard,ingress,metrics-server \
  --cni=calico \
  --nodes=3 \
  --cpus=4 --memory=4gb --disk-size=20gb \
  -p zayac

minikube delete -p zayac
```

### Тэст в minikube для приложения

```bash
kubectl create namespace app-diplom

# Создание секрета в namespace app-diplom
kubectl create secret docker-registry yc-registry \
  --docker-server=cr.yandex \
  --docker-username=json_key \
  --docker-password="$(cat ../terraform/secret/terraform-sa-key.json)" \
  -n app-diplom

make up_app-diplom

kubectl port-forward  -n app-diplom service/app-zayac 8080:80
```

### Тэст в minikube для мониторинга

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

# Создание секрета в namespace monitoring
kubectl create secret docker-registry yc-registry \
  --docker-server=cr.yandex \
  --docker-username=json_key \
  --docker-password="$(cat ../terraform/secret/terraform-sa-key.json)" \
  -n monitoring

make up_monitoring

# Получение пароля Grafana
kubectl get secret -n monitoring kube-prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d; echo

kubectl port-forward -n monitoring service/kube-prometheus-grafana 3000:80
kubectl port-forward -n monitoring service/kube-prometheus-kube-prome-prometheus 9090:9090
kubectl port-forward -n monitoring service/kube-prometheus-kube-prome-alertmanager 9093:9093
```