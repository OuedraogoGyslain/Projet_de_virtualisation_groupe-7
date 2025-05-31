#!/bin/bash

# --- Installation et configuration de MariaDB (maître) ---

echo "[INFO] Mise à jour des paquets"
sudo apt-get update -y

echo "[INFO] Installation de MariaDB"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

echo "[INFO] Configuration initiale de la base de données"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS Test_BD;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'vagrant';"
sudo mysql -e "GRANT ALL PRIVILEGES ON Test_BD.* TO 'admin'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "[INFO] Création de la table Etudiant"
sudo mysql Test_BD -e "CREATE TABLE IF NOT EXISTS Etudiant (matricule INT PRIMARY KEY, nom VARCHAR(40), prenom VARCHAR(90));"

echo "[INFO] Configuration du fichier MariaDB pour la réplication"
sudo sed -i '/^\[mysqld\]/a server-id = 1\nlog_bin = /var/log/mysql/mysql-bin.log\nbind-address = 0.0.0.0' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "[INFO] Redémarrage de MariaDB"
sudo systemctl restart mariadb

echo "[INFO] Création de l'utilisateur de réplication"
sudo mysql -e "CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'vagrant';"
sudo mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "[INFO] Génération du dump avec verrouillage temporaire"
sudo mysql -e "FLUSH TABLES WITH READ LOCK;"
sudo mysqldump -u root -pvagrant --databases Test_BD --routines --events --flush-logs --master-data=2 --single-transaction > /vagrant/master_dump.sql
sudo mysql -e "UNLOCK TABLES;"

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

echo "[INFO] Configuration terminée avec succès."
