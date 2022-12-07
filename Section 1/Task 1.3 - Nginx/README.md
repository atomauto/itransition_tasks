# Текст задачи

1. Создать виртуальную машину, установить nginx, php-fpm, mysql. 
2. Изменить конфигурацию nginx: запустить его на порту 8080. Установить дополнительный nginx (можно virtualhost, в случае, когда nginx будет бэком) на порту 80 и настроить на нем reverse proxy. Настроить логгирование на бэк веб сервере, чтобы отображались x-forwarded-for, server hostname в логах сервера. 
3. Установить на бэк сервер wordpress
4. Настроить в nginx кэш по условиям: кэшировать только те запросы, где есть utm_source=
5. Проверить, настроена ли ротация логов. Если нет - настроить. Добавить в cron задачу, которая будет находить и удалять файлы в папке /tmp, с даты создания которых прошло больше 14 дней и размер которых больше 5 Мб.
6. Скрыть версии nginx, php на серверах, используемых для выполнения заданий. Поставить расширение wappalyzer для chrome, проверить информацию по версиям. Сделать скриншоты до скрытия версий и после. Залить их в репозиторий.

# Документация

* Nginx
	- Кеширование с Nginx: https://highload.today/keshirovanie-s-nginx/
	- Использование if в Nginx: https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/
	- Пример настройки кеширования и изменения URI: https://gist.github.com/a-vasyliev/de8ffc6c6aa74cdeadfe
	- ngx_http_log_module: http://nginx.org/ru/docs/http/ngx_http_log_module.html
* Apache
	- Кеширование в Apache: https://httpd.apache.org/docs/2.4/caching.html
	- Mod_log_config: https://httpd.apache.org/docs/current/mod/mod_log_config.html
* Troubleshooting в Linux
	- ps: https://losst.pro/komanda-ps-v-linux
	- top htop: https://losst.pro/komanda-ps-v-linux
	- lsof: https://rtfm.co.ua/ispolzovanie-utility-lsof-v-primerax/
	- df: https://losst.ru/komanda-df-linux
	- strace: https://rtfm.co.ua/linux-strace-otslezhivaem-vypolnenie-processa/
	- log файлы: https://habr.com/ru/post/332502/
* видео:
	- 10 Advanced Linux Troubleshooting Tips: https://www.youtube.com/watch?v=J73f6va-C_s