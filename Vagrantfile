require 'socket'

hostname = Socket.gethostname
localmachineip = IPSocket.getaddress(Socket.gethostname)
puts %Q{ This machine has the IP '#{localmachineip} and host name '#{hostname}'}

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = '2'
#variables par défaut
centos_box_name = 'centos/7'
NETWORK_BASE = '192.168.50'
INTEGRATION_START_SEGMENT = 20

$miscellany = <<SCRIPT
yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct nfs-utils
sudo cp /vagrant/yum.repos /etc/yum.repos.d/open.repo
sudo cp /vagrant/deploy.sh /home/vagrant/deploy.sh
yum clean all ; yum repolist
yum -y update
echo "redhat" | sudo passwd root --stdin
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd restart
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false

  config.landrush.enabled = true
  config.landrush.tld = 'wescale.fr'
  config.landrush.guest_redirect_dns = false 

  config.vm.provider "virtualbox" do |v|
     v.memory = 1024
     v.cpus = 1
  end
  
  config.vm.define :nfs do |nfshost|
    nfshost.vm.box = centos_box_name
    nfshost.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT + 4}"
    nfshost.vm.hostname = "nfs.wescale.fr"
  end

  config.vm.define :master do |master|
    master.vm.box = centos_box_name
    #master.vm.box_url = centos_box_url
    master.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT}"
    master.vm.hostname = "paas.wescale.fr"
    master.vm.provision "shell", inline: "sudo yum -y install centos-release-openshift-origin37"
  end

  config.vm.define :node1 do |node|
    node.vm.box = centos_box_name
    #node.vm.box_url = centos_box_url
    node.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT + 1}"
    node.vm.hostname = "paas-node-infra.wescale.fr"
    node.vm.provision "shell", inline: "sudo yum -y install centos-release-openshift-origin37"
  end
 
  config.vm.define :node2 do |node|
    node.vm.box = centos_box_name
    #node.vm.box_url = centos_box_url
    node.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT + 2}"
    node.vm.hostname = "paas-node-app.wescale.fr"
    node.vm.provision "shell", inline: "sudo yum -y install centos-release-openshift-origin37"
  end

  config.vm.define :admin do |admin|
    admin.vm.box = centos_box_name
    admin.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT + 3}"
    admin.vm.hostname = "paas-admin.wescale.fr"
    admin.vm.provision "shell", inline: "sudo yum -y install atomic-openshift-utils"
    admin.vm.provision "shell", inline: "sudo cp -f /vagrant/etc_ansible_hosts /etc/ansible/hosts"
  end

config.vm.provision "shell", inline: $miscellany

end

