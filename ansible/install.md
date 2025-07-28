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

```bash
cd ./kubernetes
```

### Установка Kubernetes

```bash
ansible-playbook -i inventory.ini setup.yaml 
```

### Замена сертификатов кластера

```bash
ansible-playbook -i inventory.ini expiration.yaml 
```
