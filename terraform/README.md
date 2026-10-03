# Создание облачной инфраструктуры

## Подготовительный этап перед основной инфраструктурой

### Создание сервисного аккаунта для Terraform и подготовку backend:

```bash
cd 00_cloud_setup
terraform init -upgrade
terraform plan
terraform apply --auto-approve
cd ..
```

### Основная инфраструктура

```bash
cd 01_main
terraform init -reconfigure -backend-config=backend.hcl -upgrade
terraform plan
terraform apply --auto-approve 
cd ..
```

### Прочие команды

```bash
terraform destroy --auto-approve
terraform fmt
``` 