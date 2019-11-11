# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vbguest.auto_update = false
  config.vm.define "GiffitsStarterKit" do |machine_id|
      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://vagrantcloud.com/search.
      machine_id.vm.box = "debian/stretch64"

      # Disable automatic box update checking. If you disable this, then
      # boxes will only be checked for updates when the user runs
      # `vagrant box outdated`. This is not recommended.
      # config.vm.box_check_update = false

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine. In the example below,
      # accessing "localhost:8080" will access port 80 on the guest machine.
      # NOTE: This will enable public access to the opened port
       machine_id.vm.network "forwarded_port", guest: 80, host: 80
       machine_id.vm.network "forwarded_port", guest: 443, host: 443
       machine_id.vm.network "forwarded_port", guest: 9200, host: 9200
       machine_id.vm.network "forwarded_port", guest: 8080, host: 8080

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine and only allow access
      # via 127.0.0.1 to disable public access
      # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
       machine_id.vm.network "private_network", ip: "192.168.33.10"

      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      # config.vm.network "public_network"

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options.
       machine_id.vm.synced_folder ".", "/var/www", type: "smb", smb_username: "GiffitsUser" ,smb_password: "TeamGroupEcu", :mount_options => ["mfsymlinks,dir_mode=0777,file_mode=0777,vers=3.0"]
       machine_id.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: "GiffitsUser" ,smb_password: "TeamGroupEcu", :mount_options => ["mfsymlinks,dir_mode=0777,file_mode=0777,vers=3.0"]

      # Provider-specific configuration so you can fine-tune various
      # backing providers for Vagrant. These expose provider-specific options.
      # Example for VirtualBox:
      #

      config.vm.provider "virtualbox" do |vb|
         vb.memory = "4096"
         vb.cpus = 4
         vb.name = "GiffitsStarterKit"
      end

      machine_id.vm.provision "shell", inline: <<-SHELL
         apt-get update
         apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common apache2-utils vim jq
         curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
         add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
         apt update
         apt -y install docker-ce
         usermod -aG docker $USER
         curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
         chmod +x /usr/local/bin/docker-compose
      SHELL

      machine_id.vm.provision "shell", path: "infrastructure/scripts/setup-swarm.sh"

      machine_id.vm.provision "shell", path: "infrastructure/scripts/setup-dive.sh"

      machine_id.vm.provision "shell", :run => 'always', path: "infrastructure/scripts/setup-portainer.sh"

      machine_id.vm.provision "shell", inline: <<-SHELL
            mkdir -p /var/data/mysql || true
            chmod -R 0777 /var/data/mysql
      SHELL

      machine_id.vm.provision "shell", :run => 'always', :path => "infrastructure/scripts/run-container.sh"

      machine_id.vm.provision "shell", :run => 'always', :path => "infrastructure/scripts/print-ready-message.sh"

      machine_id.vm.post_up_message = ""
  end
end
