#!/bin/bash

echo "[CLIENT] Provisioning de la VM client..."

# Mettre à jour les paquets
sudo apt-get update -y

# Installer curl et autres outils utiles
sudo apt-get install -y curl wget net-tools dnsutils

# Optionnel : Ajouter les IP et noms des autres machines au /etc/hosts
echo "192.168.56.10 lb"         | sudo tee -a /etc/hosts
echo "192.168.56.11 web1"       | sudo tee -a /etc/hosts
echo "192.168.56.12 web2"       | sudo tee -a /etc/hosts
echo "192.168.56.13 db-master"  | sudo tee -a /etc/hosts
echo "192.168.56.14 db-slave"   | sudo tee -a /etc/hosts
echo "192.168.56.15 monitoring" | sudo tee -a /etc/hosts

# Exemple de test de connectivité vers les serveurs web
echo "[CLIENT] Test HTTP vers load balancer (lb)..."
curl -s http://lb:8080 || echo "Échec de la requête vers lb:8080"

# Exemple de test de latence réseau
echo "[CLIENT] Ping vers les autres machines :"
ping -c 2 lb
ping -c 2 web1
ping -c 2 web2

# Fin du provisioning
echo "[CLIENT]  terminé."
