#!/bin/bash

# --- Installation et configuration de MariaDB (esclave) ---

echo "[INFO] Mise à jour des paquets"
sudo apt-get update -y

echo "[INFO] Installation de MariaDB"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

echo "[INFO] Configuration du fichier MariaDB pour la réplication (slave)"
sudo sed -i '/^\[mysqld\]/a server-id = 2\nrelay_log = /var/log/mysql/mysql-relay-bin.log' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "[INFO] Redémarrage de MariaDB"
sudo systemctl restart mariadb

echo "[INFO] Restauration du dump depuis le maître"
sudo mysql -u root -pvagrant < /vagrant/master_dump.sql

# --- Configuration du slave pour la réplication ---

# Remplace cette IP par celle du master si différente
MASTER_HOST="192.168.56.13"

echo "[INFO] Configuration du slave pour se connecter au maître"
sudo mysql -u root -pvagrant -e "STOP SLAVE;
CHANGE MASTER TO
  MASTER_HOST='$MASTER_HOST',
  MASTER_USER='repl',
  MASTER_PASSWORD='vagrant',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=4;
START SLAVE;"

echo "[INFO] Vérification de l'état du slave"
sudo mysql -u root -pvagrant -e "SHOW SLAVE STATUS\G"

# --- Installation de Node Exporter ---

echo "[INFO] Installation de Node Exporter"
cd /tmp
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/

echo "[INFO] Création de l'utilisateur node_exporter"
sudo useradd --no-create-home --shell /bin/false node_exporter

echo "[INFO] Configuration du service systemd pour Node Exporter"
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Activation et démarrage de Node Exporter"
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "[INFO] Configuration de db-slave terminée avec succès."
