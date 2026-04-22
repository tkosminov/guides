# Замена network плагина

## Замена плагина

| на пример **weave** -> **flannel**

1. Устанавливаю flannel на мастер ноде
   ```bash
   kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
   ```
2. Ждем пока flannel запустится на всех нодах
   ```bash
   kubectl get pods -n kube-flannel -l app=flannel -o wide
   ```
3. На мастер ноде удаляю weave из кластера
   ```bash
   kubectl delete ds weave-net -n kube-system
   ```
4. По очереди очищаю ноды от weave (Сначала salve! Последним master!)
   1. На мастере вывожу ноду из кэсплуатации (master ноду не нужно drain, т.к. она последняя!)
      ```bash
      kubectl cordon ${NODE_NAME}
      kubectl drain ${NODE_NAME} --ignore-daemonsets --delete-emptydir-data
      ```
   2. Затем захожу на ноду по ssh и очищаю от weave
      ```bash
      sudo systemctl stop kubelet
      systemctl stop containerd

      sudo ip link delete weave
      sudo ip link delete datapath
      sudo ip link delete weave-bridge
      sudo ip link delete vethwe-bridge

      sudo ip neigh flush dev weave

      sudo rm /etc/cni/net.d/10-weave.conflist
      sudo rm -f /var/lib/weave/weave-*
      sudo rm -f /opt/cni/bin/weave-*

      sudo systemctl start containerd
      sudo systemctl start kubelet
      ```
   3. Затем на мастере возвращаю ноду (master ноду не нужно uncordon, т.к. она последняя!)
      ```bash
      kubectl uncordon ${NODE_NAME}
      ```
   4. На мастер ноде проверяем подключение ноды перед тем как перейти к очистке следующей
      ```bash
      kubectl get nodes
      kubectl get pods -A -o wide
      ```
5. Удаляю остатки weave
   ```bash
   kubectl delete clusterrole weave-net
   kubectl delete clusterrolebinding weave-net
   kubectl delete serviceaccount weave-net -n kube-system
   kubectl delete configmap weave-net-config -n kube-system
   ```
6. Перезапускаю все системные поды
   ```bash
   kubectl delete pods -n kube-flannel --all
   ```

## Переустановка сети

1. Чтобы общий pod range покрывал несколько `/16` сетей и каждой ноде выделялся отдельный `/16`. Общее количество нод при этом ограничивается до 4-х!
   В файле:
   ```bash
   nano /etc/kubernetes/manifests/kube-controller-manager.yaml
   ```
   Меняем:
   ```text
   --cluster-cidr=10.244.0.0/16
   ```
   На:
   ```bash
   --allocate-node-cidrs=true
   --cluster-cidr=10.244.0.0/14
   --node-cidr-mask-size=16
   ```
2. Меняем ConfigMap Flannel
   ```bash
   kubectl -n kube-flannel edit cm kube-flannel-cfg
   ```
   В ConfigMap:
   ```text
   namespace: kube-flannel
   name: kube-flannel-cfg
   ```
   В `net-conf.json` было:
   ```json
   "Network": "10.244.0.0/16"
   ```
   Стало:
   ```json
   "Network": "10.244.0.0/14"
   ```
3. Меняем на каждой slave ноде по очереди
   1. Отключаем ноду на мастере
      ```bash
      kubectl cordon ${NODE_NAME}
      kubectl drain ${NODE_NAME} --ignore-daemonsets --delete-emptydir-data --force --grace-period=0
      ```
   2. На ноде очищаем старые сетевые состояния
      ```bash
      systemctl stop kubelet
      systemctl stop containerd

      rm -rf /var/lib/cni/*
      rm -rf /run/flannel/*
      ip link delete cni0 || true
      ip link delete flannel.1 || true

      systemctl start containerd
      systemctl start kubelet
      ```
   3. Проверяем на мастере - kubelet должен сам зарегистрировать ноду заново, контроллер должен сам назначить новый /16
      ```bash
      kubectl get nodes -o wide
      kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
      ```
   4. Если пункт 3 не сработал
      Удаляем ноду на master ноде:
      ```bash
      kubectl delete ${NODE_NAME}
      ```
      Перезапускаем kubelet на slave ноде
      ```bash
      systemctl restart kubelet
      ```
   5. Возвращаем slave ноду в эксплуатацию
      ```bash
      kubectl uncordon ${NODE_NAME}
      ```
4. Перезапустить на master ноде
   flannel:
   ```bash
   kubectl delete pods -n kube-flannel --all
   ```
   coredns, kube-proxy и прочие
   ```bash
   kubectl delete pods -n kube-system --field-selector=status.phase=Running
   ```


   <!-- ```bash
   kubectl create -f - <<'EOF'
   apiVersion: v1
   kind: Node
   metadata:
   name: ${NODE_NAME}
   spec:
   unschedulable: true
   podCIDR: 10.245.0.0/16
   podCIDRs:
   - 10.245.0.0/16
   EOF
   ``` -->