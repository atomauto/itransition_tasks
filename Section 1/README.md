# Section 1. Linux and Bash.
В данной секции решены задачи, связанные с базовым администрированием Linux. Каждая задача находится в соответствующей директории.
- [Task 1.1 - Linux and Bash](https://github.com/atomauto/itransition_tasks/tree/6d049f09d2b6c8a92cb9c282af4edba4ef786487/Section%201/Task%201.1%20-%20Linux%20and%20Bash%20-%20General%20tasks)  
Простые скрипты и задачи на Bash, в данный момент решено только 9 из 15 задач.
- [Task 1.2 - Linux - Troubleshoot Linux](https://github.com/atomauto/itransition_tasks/tree/6d049f09d2b6c8a92cb9c282af4edba4ef786487/Section%201/Task%201.2%20-%20Linux%20-%20Troubleshoot%20linux)  
Данная виртуальная машина Vagrant (провайдер Virtualbox) со сломанным Wordpress. Требуется найти и исправить ошибку без переустановки какого-либо ПО.
- [Task 1.3 - Nginx](https://github.com/atomauto/itransition_tasks/tree/6d049f09d2b6c8a92cb9c282af4edba4ef786487/Section%201/Task%201.3%20-%20Nginx)  
Требуется установить LEMP + Wordpress c reverse proxy на виртуальной машине, в своём решении использую Nginx как в качестве reverse proxy, так и backend сервера. Нужно сделать кэширование на стороне reverse proxy только для определенных запросов, скрыть токены PHP и NGINX, сделать ротацию логов. В качестве решения написан скрипт, который производит все необходимые манипуляции с помощью Vagrant образа Debian и пробрасывает порты, результат можно воспроизвести запустив скрипт на любом компьютере с Linux, где установлен Vagrant и Virtualbox. Использую свой кастомный motd из репозитория prepare_linux
- [Task 1.4 - LVM](https://github.com/atomauto/itransition_tasks/tree/0627076a58c2c7d2e2e56bd66f866b8f934e460d/Section%201/Task%201.4%20-LVM)  
Требуется произвести базовые операции с LVM, используя для удобства файлы в качестве loopback устройств.