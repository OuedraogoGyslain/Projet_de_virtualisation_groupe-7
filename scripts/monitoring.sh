#!/bin/bash

set -e

# Mise à jour des paquets
sudo apt-get update

# Installer Prometheus
sudo apt-get install -y prometheus

# Installer Grafana
sudo apt-get install -y software-properties-common wget gnupg2 curl

# Ajouter la clé GPG de Grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Ajouter le dépôt de Grafana
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Mettre à jour et installer Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Activer et démarrer les services
sudo systemctl enable prometheus
sudo systemctl start prometheus

sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Configuration de Prometheus
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'web1'
    static_configs:
      - targets: ['192.168.56.11:9100']

  - job_name: 'web2'
    static_configs:
      - targets: ['192.168.56.12:9100']

  - job_name: 'db-master'
    static_configs:
      - targets: ['192.168.56.13:9100']

  - job_name: 'db-slave'
    static_configs:
      - targets: ['192.168.56.14:9100']

  - job_name: 'lb'
    static_configs:
      - targets: ['192.168.56.10:9100']

  - job_name: 'monitoring'
    static_configs:
      - targets: ['localhost:9100']
EOF

# Redémarrer Prometheus pour appliquer la config
sudo systemctl restart prometheus

# Ouvrir les ports (utile si UFW est activé)
sudo ufw allow 9090/tcp || true
sudo ufw allow 3000/tcp || true

# Attendre que Grafana démarre
sleep 10

# Ajouter Prometheus comme source de données Grafana via l'API
curl -X POST -H "Content-Type: application/json" -d '{
  "name":"Prometheus",
  "type":"prometheus",
  "url":"http://localhost:9090",
  "access":"proxy",
  "isDefault":true
}' http://admin:admin@localhost:3000/api/datasources
