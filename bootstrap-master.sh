#!/bin/bash
echo master > /var/tmp/role

# Packages
sudo apt-get --yes update
sudo apt-get --yes upgrade
sudo apt-get --yes install ansible git screen vim telnet tcpdump python-setuptools gcc python-dev python-pip libssl-dev libffi-dev software-properties-common

# Kargo and custom inventory
sudo git clone https://github.com/kubespray/kargo /root/kargo
sudo git clone https://github.com/adidenko/vagrant-k8s /root/vagrant-k8s
sudo cp -a /root/vagrant-k8s/kargo/inv /root/kargo/inv

# Kargo-cli
sudo git clone https://github.com/kubespray/kargo-cli.git /root/kargo-cli
sudo sh -c 'cd /root/kargo-cli && python setup.py install'

# Pip
sudo pip install kpm

# k8s deploy script and config
sudo sh -c 'cp -a ~/deploy-k8s.kargo.sh /root/ && chmod 755 /root/deploy-k8s.kargo.sh'
sudo cp -a ~/custom.yaml /root/kargo/custom.yaml

# SSH keys and config
sudo rm -rf /root/.ssh
sudo mv ~vagrant/ssh /root/.ssh
sudo echo -e 'Host 10.210.*\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null' >> /root/.ssh/config
sudo chown -R root: /root/.ssh

# Save nodes list
sudo cp ~/nodes /root/nodes

# README
sudo echo 'cd /root/kargo ; ansible-playbook -vvv -i inv/inventory.cfg cluster.yml -u root -f 7' > /root/README
