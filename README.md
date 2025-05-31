INTRODUCTION 

Dans le cadre du cours de Virtualisation et Cloud Computing, nous avons travaillé 
en groupe sur un projet visant à déployer une infrastructure virtuelle à l’aide de 
Vagrant et de scripts Bash. Ce projet nous a permis de simuler un environnement 
cloud local et de mieux comprendre les notions de déploiement automatisé, de 
gestion des machines virtuelles et de supervision d’une architecture distribuée.
 
 
I. Présentation des Outils et Technologies 
1) Vagrant et VirtualBox 
Vagrant est un outil open-source qui permet de créer, configurer et gérer des 
environnements de machines virtuelles de manière simple, reproductible et 
portable. Il utilise un fichier de configuration (Vagrantfile) pour décrire 
l’infrastructure désirée (nombre de machines, IPs, ressources, scripts de 
provisioning, etc.). Il permet de lancer plusieurs machines virtuelles avec des 
configurations précises en une seule commande. 
VirtualBox est également un logiciel de virtualisation open-source développé par 
Oracle. Il permet de créer et d'exécuter plusieurs machines virtuelles (VM) sur un 
même hôte physique, chacune avec son propre système d’exploitation, ses 
ressources matérielles simulées (processeur, RAM, disque, carte réseau, etc.). 

2) Bash et le Provisioning 
Dans le compte ce projet, Bash est utilisé pour automatiser le provisioning des 
machines virtuelles, c’est-à-dire leur configuration automatique après création. 
Chaque rôle (serveur web, base de données, etc.) a son script dédié : 
• lb.sh pour Nginx 
• web1.sh et web2.sh pour Apache 
• db-master.sh et db-slave.sh pour MySQL 
• monitoring.sh pour le monitoring  
• client.sh pour la machine cliente 

3) nginx (équilibreur de charge) 
Nginx est un serveur web léger et performant qui peut aussi agir comme un 
équilibreur de charge (load balancer). Il est largement utilisé pour répartir 
efficacement le trafic réseau entre plusieurs serveurs backend afin d’améliorer la 
disponibilité et les performances des applications web. 
Dans ce projet, la machine virtuelle lb joue le rôle de point d’entrée unique de 
l’infrastructure.  
Elle a les responsabilités suivantes : 
• Recevoir les requêtes du client via navigateur. 
• Répartir dynamiquement le trafic vers les serveurs web1 et web2 pour 
équilibrer la charge. 
• Améliorer la tolérance aux pannes : si un serveur web tombe en panne, 
l’autre peut continuer à servir les pages. 

4) Apache (Serveurs Web) 
Apache HTTP Server, couramment appelé Apache, est un des serveurs web. 
Il permet de diffuser du contenu web tel que des pages HTML, des images ou 
des scripts  aux clients via le protocole HTTP. Ce serveur, libre, bénéficie d’un 
large support au sein des distributions Linux, ce qui en fait un choix privilégié 
pour de nombreux déploiements web. 
Dans le contexte de ce projet, les machines web1 et web2 sont déployées avec 
Apache afin de : 
• Servir une page d’accueil statique permettant d’identifier le serveur en 
cours de consultation. 
• Répondre aux requêtes HTTP acheminées par le load balancer Nginx, 
installé sur la machine lb. 

5) MySQL – Réplication Maître-Esclave 
La réplication dans un système de gestion de base de données consiste à copier 
automatiquement les données d’un serveur principal vers un ou plusieurs serveurs 
secondaires. Ce mécanisme est particulièrement utile pour garantir la 
disponibilité, la tolérance aux pannes. 
Dans le modèle maître-esclave de MySQL : 
• Le serveur maître (master) est le point central où les opérations d’écriture 
(INSERT, UPDATE, DELETE) sont effectuées. 
• Le serveur esclave (slave) reçoit une copie en temps quasi réel des 
modifications du maître et ne sert qu’aux opérations de lecture. 

6) Prometheus et Grafana 
Prometheus est une solution de monitoring open-source conçue pour collecter 
en temps réel des métriques provenant d’applications et de serveurs. Son 
fonctionnement repose sur un modèle de collecte de données en mode pull, où il 
interroge régulièrement des agents appelés exporters qui fournissent des 
informations détaillées sur les ressources système (CPU, mémoire, disque) ainsi 
que sur des services spécifiques, tels que MySQL. 
Grafana est une plateforme de visualisation de données qui permet de concevoir 
des tableaux de bord interactifs et personnalisés à partir des métriques recueillies 
par Prometheus. Elle simplifie l’analyse visuelle de la performance et de l’état 
des systèmes grâce à des graphiques, des jauges et des alertes configurables selon 
les besoins. 
