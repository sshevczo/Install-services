#!/bin/bash

# Обновляем систему
sudo apt update
sudo apt upgrade -y

# Устанавливаем необходимые зависимости
sudo apt install -y wget gnupg2

# Добавляем репозиторий Zabbix
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update

# Устанавливаем сервер Zabbix, веб-интерфейс и агент
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

# Устанавливаем MariaDB
sudo apt install -y mariadb-server

# Настраиваем базу данных для Zabbix
sudo mysql -uroot -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -uroot -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"

# Импортируем начальную схему и данные
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | sudo mysql -uzabbix -p'password' zabbix

# Настраиваем Zabbix сервер для подключения к базе данных
sudo sed -i 's/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf

# Настраиваем временную зону для PHP
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Moscow/' /etc/zabbix/apache.conf

# Перезапускаем службы
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo "Установка Zabbix завершена. Откройте веб-интерфейс, чтобы завершить настройку: http://your_server_ip/zabbix"

