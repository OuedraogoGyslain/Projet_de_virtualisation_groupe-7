# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/bionic64"

  base_ip = "192.168.56."

  machines = {
    "lb"         => 10,
    "web1"       => 11,
    "web2"       => 12,
    "db-master"  => 13,
    "db-slave"   => 14,
    "monitoring" => 15,
    "client"     => 16
  }

  machines.each do |name, ip_suffix|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: "#{base_ip}#{ip_suffix}"

       # Forward dynamique pour web1 et web2
      if ["web1", "web2"].include?(name)
        node.vm.network "forwarded_port", guest: 8080, host: 8081 + ip_suffix - 10
      end

      # Ports pour Grafana (3000) et Prometheus (9090) si c'est la VM "monitoring"
        if name == "monitoring"
              # Forward Grafana (3000) vers hôte 3001
              node.vm.network "forwarded_port", guest: 3000, host: 3001, auto_correct: true

              # Forward Prometheus (9090) vers hôte 19090
              node.vm.network "forwarded_port", guest: 9090, host: 19090, auto_correct: true
         end

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.cpus = 1
      end

      node.vm.provision "shell", path: "scripts/#{name}.sh"
    end
  end
end
