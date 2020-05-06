export ANSIBLE_IP=192.168.1.2
export PROMETHEUS_IP=192.168.1.99
export WEB_IP=192.168.1.11
export ATTACKER_IP=192.168.1.12

plugin:
	vagrant plugin install vagrant-hosts

up: plugin
	vagrant up

chmod:
	chmod 600 .vagrant/machines/*/virtualbox/private_key

rsync-auto:
	vagrant rsync-auto

# SSHのオプションとSSH先
# $1：VMマシン名(VirtualBox側の名前)
# $2：VM側のIP(VirtualBox側の名前)
define ssh-option
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	-i .vagrant/machines/$1/virtualbox/private_key \
	vagrant@$2
endef
ansible: chmod
	ssh $(call ssh-option,nginx_dos_ansible,${ANSIBLE_IP})

prometheus: chmod
	ssh $(call ssh-option,prometheus,${PROMETHEUS_IP})

web: chmod
	ssh $(call ssh-option,web,${WEB_IP})

attacker: chmod
	ssh $(call ssh-option,attacker,${ATTACKER_IP})

web-up:
	vagrant ssh web -c 'cd web-codes && make up'

provision:
	vagrant ssh wafu_ansible -c 'cd ansible && make provision'

clean:
	vagrant ssh web -c 'cd web-codes && make clean'
