#### Install the customised K8s Dashboard YAML

```shell
kubectl apply -f /root/dashboard.yaml
kubectl -n kubernetes-dashboard wait --for=condition=ready pod --all
```

#### The modifications here were these arguments

```shell
args:
- --namespace=kubernetes-dashboard
- --enable-skip-login
- --disable-settings-authorizer
- --enable-insecure-login
- --insecure-bind-address=0.0.0.0
```

#### and an updated service YAML

官方默认监听https 8443 需要修改协议和端口

```shell
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 9090
      targetPort: 9090
  selector:
    k8s-app: kubernetes-dashboard
```

#### Create a ServiceAccount and use the token

1. kubectl -n kubernetes-dashboard create sa admin-user
   作用：在 kubernetes-dashboard 命名空间下创建一个名为 admin-user 的 ServiceAccount。

- sa 是 serviceaccount 的缩写
- ServiceAccount 相当于 Kubernetes 里的“服务账号”，Dashboard 登录时会用这个账号的身份去访问集群

2. kubectl create clusterrolebinding admin-user --clusterrole cluster-admin --serviceaccount kubernetes-dashboard:admin-user
   作用：给刚才创建的 admin-user 绑定 cluster-admin 权限。

- clusterrolebinding：集群级别的角色绑定
- --clusterrole cluster-admin：绑定的是 Kubernetes 内置的最高权限角色（相当于 root）
- --serviceaccount kubernetes-dashboard:admin-user：指定绑定给哪个 ServiceAccount
  执行完这条命令后，admin-user 就拥有了集群的全部管理权限。

3. kubectl -n kubernetes-dashboard create token admin-user
   作用：为 admin-user 这个 ServiceAccount 生成一个临时登录 Token。

- 这个 Token 就是你在 Dashboard 登录页面输入的凭证
- 默认有效期是 1 小时（Kubernetes 1.24+ 的行为）
- 生成的 Token 会直接打印在终端上，复制粘贴到 Dashboard 登录框即可

```shell
kubectl -n kubernetes-dashboard create sa admin-user
kubectl create clusterrolebinding admin-user --clusterrole cluster-admin --serviceaccount kubernetes-dashboard:admin-user
kubectl -n kubernetes-dashboard create token admin-user
```

#### Next we need to run port-forward

```shell
kubectl -n kubernetes-dashboard port-forward service/kubernetes-dashboard 9090:9090 --address 0.0.0.0 &
```

| 资源类型                         | 作用说明                                 |
| :------------------------------- | :--------------------------------------- |
| Deployment                       | 真正运行 Dashboard 程序的 Pod（核心）    |
| Service                          | 把 Pod 暴露出来，让你能通过端口访问      |
| ServiceAccount                   | Dashboard 用来访问 Kubernetes API 的身份 |
| Secret                           | 存放证书、CSRF token 等                  |
| ClusterRole / ClusterRoleBinding | 权限控制                                 |
