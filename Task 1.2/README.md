# Task 1.2
Все действия выполняются скриптом task1.2.sh. В отличии от task1.1.sh, скрипт использует sudo. Скрипт поддерживает параметр kubectl_release, с помощью которого можно выбрать определенную версию kubectl. Реализована проверка поддержки виртуализации. В случае отсутствия поддержки виртуализации или если --driver docker, скрипт использует в качестве драйвера для minicube docker. 
# Текст задачи
Данная задача должна выполняться локально (на вашем компьютере). Предполагаемое окружение: дистрибутив Linux.
Результат выполнения данной задачи описан в условии и перечислен в чеклисте.

Работа с Kubernetes
Установите minikube согласно инструкции на официальном сайте.
Создайте namespace для деплоя простого веб приложения.
Напишите deployments файл для установки в Kubernetes простого веб приложения, например https://github.com/crccheck/docker-hello-world.
Установите в кластер ingress контроллер 
Напишите и установите Ingress rule для получения доступа к своему приложению.
В качестве результата работы сделайте скриншоты результата выполнения команд:
- kubectl get pods -A
- kubectl get svc
- kubectl get all
а также все написанные вами файлы конфигурации.
# Документация
Kubernetes:
- Документация по Kubernetes: https://kubernetes.io/ru/docs/home/
- Шпаргалка по kubectl: https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/
- Основы Kubernetes: https://habr.com/ru/post/258443/
- Установка Kubernetes с помощью Minikube: https://kubernetes.io/ru/docs/setup/learning-environment/minikube/
- Установка Kubernetes с помощью Kubespray: https://kubernetes.io/docs/setup/production-environment/tools