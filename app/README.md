# Создание тестового приложения

## 

```bash
# Сборка контейнера
cd app
docker build -f app.Dockerfile --provenance=false --sbom=false -t cr.yandex/<registry-id>/diplom-app:v1 .

# Локальный тэст
docker run --rm -d --name test-app -p 8080:80 cr.yandex/<registry-id>/diplom-app:v1
docker stop test-app

docker push cr.yandex/<registry-id>/diplom-app:v1
yc container image list --registry-id <registry-id>
```


### Прочие команды

```bash
docker system prune -a
docker builder prune -af
```