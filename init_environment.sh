#!/bin/bash
set -e

echo "=========================================="
echo " 🚀 Kubernetes 学习环境初始化脚本"
echo "=========================================="

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "=========================================="
echo " 0. 基础依赖检查"
echo "=========================================="

if ! command_exists sudo; then
    echo "❌ sudo 未安装，请先安装 sudo"
    exit 1
fi

if ! command_exists curl; then
    echo "⬇️ 安装 curl..."
    sudo apt-get update
    sudo apt-get install -y curl
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

# 非 root 用户才需要加入 docker 组
if [ "$EUID" -ne 0 ]; then
    if groups "$USER" | grep -q "\bdocker\b"; then
        echo "✅ 当前用户已在 docker 组中"
    else
        echo "➕ 将当前用户加入 docker 组"
        sudo usermod -aG docker "$USER"
        echo "⚠️ 需要重新登录，或执行：newgrp docker"
    fi
else
    echo "ℹ️ 当前是 root 用户，跳过 docker 用户组配置"
fi

# echo "=========================================="
# echo " 2. Minikube 安装/检查"
# echo "=========================================="

# if command_exists minikube; then
#     echo "✅ Minikube 已安装："
#     minikube version
# else
#     echo "⬇️ 安装 Minikube..."
#     curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
#     sudo install minikube-linux-amd64 /usr/local/bin/minikube
#     rm -f minikube-linux-amd64
#     minikube version
# fi

echo "=========================================="
echo " 2. Kind 安装/检查"
echo "=========================================="

if command_exists kind; then
    echo "✅ Kind 已安装："
    kind version
else
    echo "⬇️ 安装 Kind..."

    curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

    chmod +x kind

    sudo mv kind /usr/local/bin/kind

    echo "✅ Kind 安装完成"
    kind version
fi

echo "=========================================="
echo " 3. Kubectl 安装/检查"
echo "=========================================="

if command_exists kubectl; then
    echo "✅ kubectl 已安装："
    kubectl version --client
else
    echo "⬇️ 安装 kubectl..."
    K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

    curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl

    kubectl version --client
fi


echo "=========================================="
echo " 4. 安装go环境"
echo "=========================================="
if command_exists gol; then
    echo "✅ go 已安装："
    go version
else
    echo "⬇️ 安装 go..."
    curl -LO "https://go.dev/dl/go1.26.4.linux-386.tar.gz"
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.4.linux-386.tar.gz && rm -rf go1.26.4.linux-386.tar.gz
    go version
fi


echo "=========================================="
echo " 5. bash 自动补全配置"
echo "=========================================="

if ! dpkg -l | grep -q bash-completion; then
    echo "⬇️ 安装 bash-completion..."
    sudo apt-get update
    sudo apt-get install -y bash-completion
else
    echo "✅ bash-completion 已安装"
fi

sudo mkdir -p /etc/bash_completion.d

echo "➕ 更新 kubectl 自动补全"
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null

echo "=========================================="
echo " 5. 验证安装结果"
echo "=========================================="

if command_exists docker; then
    echo "Docker: $(docker --version)"
else
    echo "Docker: 未安装"
fi

# if command_exists minikube; then
#     echo "Minikube:"
#     minikube version
# else
#     echo "Minikube: 未安装"
# fi

if command_exists kind; then
    echo "kind:"
    kind version
else
    echo "kind: 未安装"
fi

if command_exists kubectl; then
    echo "Kubectl:"
    kubectl version --client
else
    echo "Kubectl: 未安装"
fi

if command_exists go; then
    echo "go:"
    go version
else
    echo "go: 未安装"
fi

echo "=========================================="
echo " 🎉 环境初始化完成"
echo "=========================================="
echo "💡 下一步建议："
echo "1. 查看节点：kubectl get nodes"
echo "2. 查看系统 Pod：kubectl get pods -A"
echo "=========================================="