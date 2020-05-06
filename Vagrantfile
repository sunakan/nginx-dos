# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

VAGRANT_BOX_UBUNTU  = 'bento/ubuntu-18.04'
VAGRANT_BOX_DEFAULT = VAGRANT_BOX_UBUNTU

vm_specs = [
#  { name: 'prometheus', ip: '192.168.1.99', cpus: 1, memory: 512*4, sync_dir: 'prometheus-codes' },
  { name: 'web',        ip: '192.168.1.11', cpus: 2, memory: 512*5, sync_dir: 'web-codes' },
  { name: 'attacker',   ip: '192.168.1.12', cpus: 1, memory: 512*5, sync_dir: 'attacker-codes' },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ##############################################################################
  # 共通
  ##############################################################################
  config.vm.synced_folder '.', '/vagrant', disabled: true

  ##############################################################################
  # 各VM
  ##############################################################################
  vm_specs.each do |spec|
    config.vm.define spec[:name] do |machine|
      machine.vm.box      = spec[:vagrant_box] || VAGRANT_BOX_DEFAULT
      machine.vm.hostname = spec[:name]
      machine.vm.network 'private_network', ip: spec[:ip]
      machine.vm.provider :virtualbox do |vb|
        vb.name   = spec[:name]
        vb.cpus   = spec[:cpus]
        vb.memory = spec[:memory]
      end
      if dir = spec[:sync_dir]
        machine.vm.synced_folder './' + dir, '/home/vagrant/' + dir,
          create: true, type: :rsync, owner: :vagrant, group: :vagrant,
          rsync__exclude: ['*.swp']
      end
    end
  end

  ##############################################################################
  # Ansibleをするためだけの初期化用VM
  ##############################################################################
  config.vm.define :nginx_dos_ansible do |machine|
    machine.vm.box      = VAGRANT_BOX_UBUNTU
    machine.vm.hostname = 'nginx-dos-ansible'
    machine.vm.network 'private_network', ip: '192.168.1.2'
    machine.vm.provider :virtualbox do |vb|
      vb.gui    = false
      vb.name   = machine.vm.hostname
      vb.memory = 512 * 1
      vb.cpus   = 1
    end
    machine.vm.synced_folder './ansible', '/home/vagrant/ansible',
      create: true, type: :rsync, owner: :vagrant, group: :vagrant,
      rsync__exclude: ['*.swp']
    # vagrant-hosts pluginで各VM同士がhost名でアクセス可能
    machine.vm.provision 'shell', privileged: false, inline: <<-SHELL
      sudo apt update
      sudo apt install --assume-yes python3-pip make sshpass
      pip3 install --user ansible
    SHELL
  end

  ##############################################################################
  # 共通：vagrant-hosts pluginで各VM同士がhost名でアクセス可能
  ##############################################################################
  config.vm.provision :hosts, :sync_hosts => true
end
