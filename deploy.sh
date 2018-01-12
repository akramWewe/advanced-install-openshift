ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
for host in paas.mousquetaires.com paas-node-infra.mousquetaires.com paas-node-app.mousquetaires.com; \
    do ssh-copy-id -i /root/.ssh/id_rsa.pub $host; \
    done
ansible-playbook /home/vagrant/openshift-ansible/playbooks/byo/config.yml



