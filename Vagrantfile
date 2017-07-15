# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV["LC_ALL"] = "en_US.UTF-8"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize any other parameters
    vb.customize [
     'modifyvm',                :id,
     '--memory',                '2048',
     '--cpus',                  '4',
    #  '--paravirtprovider',      'kvm', # can be set to "paravirt"
     '--ioapic',                'on', # turn on I/O APIC
     '--natdnsproxy1',          'on',
     '--uartmode1',             'disconnected', # disable ugly log cloudimg-consol.log file
     '--natdnshostresolver1',   'on']

  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
   config.vm.box_check_update = false

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # config.vm.define "etcd" do |web|
  #   web.vm.hostname = "etcd.vagrant"
  #   web.hostsupdater.aliases = ["etcd.vagrant"]
  #   # web.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  #   web.hostmanager.aliases = %w(etcd.vagrant)
  #   web.vm.network "private_network", ip: "192.168.80.55"
  #   # config.vm.provision "shell", path: "./provision_master.sh"
  # end

  config.vm.define "etcd" do |web|
    web.vm.hostname = "etcd.vagrant"
    web.hostsupdater.aliases = ["etcd.vagrant"]
    # web.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
    web.hostmanager.aliases = %w(etcd.vagrant)
    web.vm.network "private_network", ip: "192.168.80.50"

    web.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "salt/config/minion"
      salt.run_highstate = true
      salt.verbose = true
    end

  end

  config.vm.define "k8z-master" do |web|
    web.vm.hostname = "k8z-master.vagrant"
    web.hostsupdater.aliases = ["k8z-master.vagrant"]
    # web.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
    web.hostmanager.aliases = %w(k8z-master.vagrant)
    web.vm.network "private_network", ip: "192.168.80.10"
    # config.vm.provision "shell", path: "./provision_master.sh"
    web.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "salt/config/minion"
      salt.run_highstate = true
      salt.verbose = true
    end
  end

  config.vm.define "k8z-minion-001" do |web|
    web.vm.hostname = "k8z-minion-001.vagrant"
    web.hostsupdater.aliases = ["k8z-minion-001.vagrant"]
    # web.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
    web.hostmanager.aliases = %w(k8z-minion-001.vagrant)
    web.vm.network "private_network", ip: "192.168.80.20"
    web.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "salt/config/minion"
      salt.run_highstate = true
      salt.verbose = true
    end
  end

  config.vm.define "k8z-minion-002" do |web|
    web.vm.hostname = "k8z-minion-002.vagrant"
    web.hostsupdater.aliases = ["k8z-minion-002.vagrant"]
    # web.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
    web.hostmanager.aliases = %w(k8z-minion-002.vagrant)
    web.vm.network "private_network", ip: "192.168.80.30"
    web.vm.provision :salt do |salt|
      salt.masterless = true
      salt.minion_config = "salt/config/minion"
      salt.run_highstate = true
      salt.verbose = true
    end
  end

end
