# [ansible](https://github.com/ansible/ansible)

## Установка

```bash
pip3 install ansible
```

## Запуск

```bash
ansible-playbook -i inventory.ini playbook.yaml 
```

## Kubernetes example

* Поменять IP нод в `./kubernetes/inventory.ini`
* Поменять энвы в `./kubernetes/vars/env.yaml`



<!-- 
```bash
multipass launch 22.04 --cpus 2 --disk 20G --memory 2G --name slave

multipass exec slave -- bash

multipass stop slave

multipass delete slave

multipass purge
```
-->



<!-- 
- name: wait until apt lock is released
  shell: lsof -w /var/lib/apt/lists/lock | wc -l
  register: lock
  until: lock.stdout == "0"
  retries: 10
  delay: 10 
-->