# Создание тестового приложения

## Сборка контейнера

```bash
cd app
docker build -f app.Dockerfile --provenance=false --sbom=false -t cr.yandex/<registry-id>/diplom-app:v1 .
```

### Локальный тэст
```bash
docker run --rm -d --name test-app -p 8080:80 cr.yandex/<registry-id>/diplom-app:v1
docker stop test-app
```

### Отправака в Registry

```bash
docker push cr.yandex/<registry-id>/diplom-app:v1
yc container image list --registry-id <registry-id>
```

### Прочие команды

```bash
docker system prune -af
docker builder prune -af
```