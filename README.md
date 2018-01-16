# advanced-install-openshift
It's a Vagrant project to an advanced installation of OpenShift Origin with Ansible


Prerequisites:

Install Vagrant & VirtualBox
Install des plugins Vagrant vagrant-hostmanager & landrush


Run

$ vagrant landrush start
$ vagrant up

( .... wait about 10 minutes) and 5 VMs will provisioned: master, node infra, node app, admin, nfs

Configure NFS server:
$ vagrant ssh nfs
$ service nfs start
$ service rpcbind start
$ mkdir -p /exports/volumes/pv{1..10} && mkdir -p /exports/volumes/registry
$ chown nfsnobody:nfsnobody /exports/volumes
$ chown nfsnobody:nfsnobody /exports/volumes/pv{1..10} && chown nfsnobody:nfsnobody /exports/volumes/registry
$ vim /etc/exports.d/openshift-WESCALE.exports

/exports/volumes/registry  *(rw,root_squash,no_wdelay)
/exports/volumes/pv1  *(rw,root_squash,no_wdelay)
/exports/volumes/pv2  *(rw,root_squash,no_wdelay)
/exports/volumes/pv4  *(rw,root_squash,no_wdelay)
/exports/volumes/pv3  *(rw,root_squash,no_wdelay)
/exports/volumes/pv5  *(rw,root_squash,no_wdelay)
/exports/volumes/pv6 *(rw,root_squash,no_wdelay)
/exports/volumes/pv7 *(rw,root_squash,no_wdelay)
/exports/volumes/pv8 *(rw,root_squash,no_wdelay)
/exports/volumes/pv9 *(rw,root_squash,no_wdelay)

$ exportfs -rv

In admin vm, you launch the install:

$ vagrant ssh admin
$ su - ( password Redhat
$ cd /home/vagrant && git clone https://github.com/openshift/openshift-ansible
$ cd /home/vagrant/openshift-ansible && git checkout origin/release-3.7
$ cd /home/vagrant/ && deploy.sh (password Redhat)


Verify the install:


In master vm:

$ oc login -u system:admin --config=/etc/origin/master/admin.kubeconfig
$ oc get nodes

Add another cluster admin

$ htpasswd -b htpasswd -b /etc/origin/master/htpasswd wescale wescale
$ oadm policy add-cluster-role-to-user cluster-admin Wescale




