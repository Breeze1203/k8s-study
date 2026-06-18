#!/bin/bash
set -e

echo "=========================================="
echo " 🚀 Kubernetes 学习环境初始化脚本"
echo "=========================================="

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "=========================================="
echo " 0. 基础依赖检查"
echo "=========================================="

if ! command_exists curl; then
    echo "❌ curl 未安装，正在安装..."
    sudo apt-get update && sudo apt-get install -y curl
fi

if ! command_exists sudo; then
    echo "❌ sudo 未安装，请先安装 sudo"
    exit 1
fi

echo "=========================================="
echo " 1. Docker 安装/检查"
echo "=========================================="

if command_exists docker; then
    echo "✅ Docker 已安装：$(docker --version)"
else
    echo "⬇️ 安装 Docker..."
    curl -fsSL https://get.docker.com | bash
fi

# 避免重复添加用户组
if groups $USER | grep &>/dev/null "\bdocker\b"; then
    echo "✅ 当前用户已在 docker 组中"
else
    echo "➕ 将用户加入 docker 组"
    sudo usermod -aG docker $USER
    echo "⚠️ 注意：需要重新登录或执行 newgrp docker 生效"
fi

echo "=========================================="
echo " 2. Minikube 安装/检查"
echo "=========================================="

if command_exists minikube; then
    echo "✅ Minikube 已安装：$(minikube version)"
else
    echo "⬇️ 安装 Minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm -f minikube-linux-amd64
fi

echo "=========================================="
echo " 3. Kubectl 安装/检查"
echo "=========================================="

if command_exists kubectl; then
    echo "✅ kubectl 已安装：$(kubectl version --client --short 2>/dev/null || kubectl version --client)"
else
    echo "⬇️ 安装 kubectl..."
    K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
fi

echo "=========================================="
echo " 4. bash 自动补全配置"
echo "=========================================="

if ! dpkg -l | grep -q bash-completion; then
    echo "⬇️ 安装 bash-completion..."
    sudo apt-get update && sudo apt-get install -y bash-completion
fi

# shell补全目录
sudo mkdir -p /etc/bash_completion.d

if [ ! -f /etc/bash_completion.d/kubectl ]; then
    echo "➕ 添加 kubectl 自动补全"
    kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null
else
    echo "✅ kubectl 补全已存在"
fi

echo "=========================================="
echo " 5. 验证安装结果"
echo "=========================================="

echo "Docker: $(docker --version 2>/dev/null || echo '未安装')"
echo "Minikube: $(minikube version 2>/dev/null || echo '未安装')"
echo "Kubectl: $(kubectl version --client --short 2>/dev/null || echo '未安装')"

echo "=========================================="
echo " 🎉 环境初始化完成"
echo "=========================================="
echo "💡 提示："
echo "1. 如果 docker 无权限，请重新登录或执行: newgrp docker"
echo "2. 建议使用：minikube start --driver=docker"
echo "3. kubectl get nodes 验证集群"
echo "=========================================="