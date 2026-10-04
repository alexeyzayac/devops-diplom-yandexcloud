# Создание облачной инфраструктуры

## Подготовительный этап перед основной инфраструктурой

### Создание сервисного аккаунта для Terraform и подготовку backend, regastry:

```bash
cd 00_cloud_setup
terraform init -upgrade
terraform validate
terraform plan
terraform apply --auto-approve
cd ..
```

### Основная инфраструктура

```bash
cd 01_main
terraform init -reconfigure -upgrade -backend-config=backend.hcl
terraform validate
terraform plan
terraform apply --auto-approve 
cd ..
```

### Прочие команды

```bash
terraform destroy --auto-approve
terraform fmt
``` 