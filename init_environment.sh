#!/bin/bash

# 遇到错误立即退出
set -e

echo "=========================================="
echo " 1. 开始下载并安装 Minikube..."
echo "=========================================="
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64 
minikube version

echo "=========================================="
echo " 2. 开始下载并安装 Kubectl..."
echo "=========================================="
# 自动获取最新稳定版版本号并下载
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl 
kubectl version

echo "=========================================="
echo " 3. 配置 Kubectl 自动补全..."
echo "=========================================="
# 更新源并安装 bash-completion（-y 自动确认）
sudo apt-get update && sudo apt-get install -y bash-completion

# 检查 _init_completion 是否存在，如果不存在说明当前终端还没加载完成，先加载一下系统补全
if ! type _init_completion 2>/dev/null; then
    source /usr/share/bash-completion/bash_completion
fi

# 官方推荐：直接将补全脚本生成到系统补全目录下，免去修改 .bashrc 的麻烦
sudo mkdir -p /etc/bash_completion.d
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

echo "=========================================="
echo "🎉 所有安装已完成！"
echo "💡 提示：请运行 [ source ~/.bashrc ] 或重启终端以激活自动补全。"
echo "=========================================="