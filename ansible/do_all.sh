#!/bin/bash

cd /tmp || exit

chmod 0600 ~ubuntu/.ssh/id_rsa

sudo apt update && sudo apt install -y ansible

HAPROXY=$(cat haproxy_out.txt)

# build ansible hosts here:
sed -r -i "s/HAPROXY_IP/${HAPROXY}/g" haproxy.cfg
sed -r -i "s/HAPROXY_IP/${HAPROXY}/g" hosts.yaml
COUNTER=0
for i in $(cat apache_out.txt)
do
  echo "        $i: {}" >> hosts.yaml
  echo "    server apache$COUNTER $i:80" >> haproxy.cfg
  COUNTER=$(( COUNTER + 1 ))
done

# reachability test
ansible -m ping -i hosts.yaml apache_hosts
ansible -m ping -i hosts.yaml haproxy_hosts

# run ansible playbook for apache:
#ansible-playbook -i hosts.yaml apache.yaml apache_hosts
# run haproxy playbook for haproxy:
#ansible-playbook -i hosts.yaml haproxy.yaml haproxy_hosts

# done
