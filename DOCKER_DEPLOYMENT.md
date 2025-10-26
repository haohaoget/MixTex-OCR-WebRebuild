# Docker 部署指南

本文档介绍如何使用 Docker 部署 MixTex-OCR-WebRebuild 项目，支持 linux/amd64 和 linux/arm64 架构。

## 📋 目录

- [快速开始](#快速开始)
- [Docker 构建说明](#docker-构建说明)
- [GitHub Actions 自动构建](#github-actions-自动构建)
- [部署方式](#部署方式)
- [配置说明](#配置说明)
- [故障排除](#故障排除)

## 🚀 快速开始

### 方式一：使用预构建镜像（推荐）

```bash
# 拉取镜像
docker pull ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest

# 运行容器
docker run -d \
  --name mixtex-ocr \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest
```

### 方式二：使用 Docker Compose

```bash
# 克隆项目
git clone https://github.com/haohaoget/MixTex-OCR-WebRebuild.git
cd MixTex-OCR-WebRebuild

# 确保模型文件在 model 目录中
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 方式三：GPU 加速版本

```bash
# 前置要求：安装 NVIDIA Container Toolkit
# 参考: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

# 使用 Docker Compose 启动 GPU 版本
docker-compose --profile gpu up -d

# 或者直接运行 GPU 容器
docker run -d \
  --name mixtex-ocr-gpu \
  --gpus all \
  -p 8001:8000 \
  -v $(pwd)/model:/app/model:ro \
  mixtex-ocr-gpu:latest
```

### 方式四：本地构建

```bash
# CPU 版本
docker build -t mixtex-ocr .

# GPU 版本
docker build -f Dockerfile.gpu -t mixtex-ocr-gpu .

# 运行容器
docker run -d \
  --name mixtex-ocr \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  mixtex-ocr
```

## 🏗️ Docker 构建说明

### 多架构支持

本项目使用 Docker Buildx 支持多架构构建：

- **linux/amd64**: 标准 x86_64 架构
- **linux/arm64**: ARM 64位架构（如 Apple Silicon M1/M2）

### 构建特性

- **多阶段构建**: 分离前端和后端构建，优化镜像大小
- **缓存优化**: 使用 GitHub Actions 缓存加速构建
- **安全扫描**: 集成 Trivy 漏洞扫描
- **健康检查**: 内置容器健康检查

### 本地多架构构建

```bash
# 设置 Buildx
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap

# 构建多架构镜像
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag mixtex-ocr:latest \
  --push .
```

## 🔄 GitHub Actions 手动构建

### 触发方式

现在使用手动触发模式，可以在 GitHub 仓库的 Actions 页面手动运行构建：

1. 进入 GitHub 仓库的 **Actions** 页面
2. 选择 **Build and Push Docker Image** 工作流
3. 点击 **Run workflow** 按钮
4. 配置构建参数：
   - **Build type**: 选择构建类型
     - `all`: 构建CPU和GPU版本
     - `cpu-only`: 仅构建CPU版本
     - `gpu-only`: 仅构建GPU版本
   - **Push images**: 是否推送到镜像仓库
   - **Version tag**: 自定义版本标签（可选）

### 构建参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| build_type | 构建类型 | all |
| push_images | 是否推送镜像 | true |
| version_tag | 版本标签 | 空 |

### 构建流程

1. **代码检出**: 获取最新代码
2. **设置 Buildx**: 配置多架构构建环境
3. **登录注册表**: 使用 GitHub Token 登录 GHCR
4. **提取元数据**: 生成标签和标签信息
5. **构建推送**: 多架构构建并推送镜像
6. **镜像测试**: 拉取并测试镜像功能
7. **安全扫描**: 使用 Trivy 扫描漏洞

### 镜像标签

- `latest`: 最新版本（main 分支）
- `v1.0.0`, `v1.0`, `v1`: 版本标签
- `pr-123`: Pull Request 标签
- `main`: 分支标签

## 🚀 部署方式

### 1. 基础部署

```bash
docker run -d \
  --name mixtex-ocr \
  --restart unless-stopped \
  -p 8000:8000 \
  -v /path/to/model:/app/model:ro \
  ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest
```

### 2. Docker Compose 部署

```bash
# 基础部署
docker-compose up -d

# 带 Nginx 反向代理
docker-compose --profile with-nginx up -d
```

### 3. Kubernetes 部署

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mixtex-ocr
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mixtex-ocr
  template:
    metadata:
      labels:
        app: mixtex-ocr
    spec:
      containers:
      - name: mixtex-ocr
        image: ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: "2Gi"
            cpu: "1"
          limits:
            memory: "4Gi"
            cpu: "2"
        volumeMounts:
        - name: model-volume
          mountPath: /app/model
          readOnly: true
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: model-volume
        hostPath:
          path: /path/to/model
          type: Directory
```

## ⚙️ 配置说明

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `HOST` | `0.0.0.0` | 服务监听地址 |
| `PORT` | `8000` | 服务端口 |
| `PYTHONPATH` | `/app` | Python 路径 |
| `MODEL_PATH` | `/app/model` | 模型文件路径 |

### 卷挂载

| 路径 | 说明 | 必需 |
|------|------|------|
| `/app/model` | 模型文件目录 | 是 |
| `/app/logs` | 日志目录 | 否 |

### 端口

| 端口 | 协议 | 说明 |
|------|------|------|
| `8000` | HTTP | API 服务端口 |

### 资源要求

| 资源 | 最小值 | 推荐值 |
|------|--------|--------|
| 内存 | 2GB | 4GB |
| CPU | 1核 | 2核 |
| 存储 | 5GB | 10GB |

## 🔧 故障排除

### 常见问题

#### 1. 模型文件未找到

**错误**: `找不到有效的模型文件`

**解决**:
```bash
# 确保模型文件存在
ls -la model/
# 应包含：encoder_model.onnx, decoder_model_merged.onnx, tokenizer.json, vocab.json

# 检查挂载路径
docker exec mixtex-ocr ls -la /app/model/
```

#### 2. 内存不足

**错误**: `OOMKilled`

**解决**:
```bash
# 增加内存限制
docker run -d \
  --name mixtex-ocr \
  --memory=4g \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest
```

#### 3. 健康检查失败

**错误**: `Health check failed`

**解决**:
```bash
# 检查服务状态
docker exec mixtex-ocr curl http://localhost:8000/health

# 查看日志
docker logs mixtex-ocr
```

#### 4. 前端无法访问

**错误**: `前端页面空白`

**解决**:
```bash
# 检查静态文件
docker exec mixtex-ocr ls -la /app/static/

# 重新构建镜像
docker build --no-cache -t mixtex-ocr .
```

#### 5. GPU 不可用

**错误**: `CUDA not available` 或 `GPU device not found`

**解决**:
```bash
# 检查 NVIDIA Docker 安装
docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi

# 检查 GPU 驱动
nvidia-smi

# 检查容器 GPU 访问
docker exec mixtex-ocr-gpu nvidia-smi

# 重新安装 NVIDIA Container Toolkit
# 参考: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
```

#### 6. GPU 内存不足

**错误**: `CUDA out of memory`

**解决**:
```bash
# 限制 GPU 内存使用
docker run -d \
  --name mixtex-ocr-gpu \
  --gpus all \
  --shm-size=1g \
  -p 8001:8000 \
  -v $(pwd)/model:/app/model:ro \
  mixtex-ocr-gpu:latest

# 或者使用环境变量限制
docker run -d \
  --name mixtex-ocr-gpu \
  --gpus all \
  -e CUDA_VISIBLE_DEVICES=0 \
  -e CUDA_MEMORY_FRACTION=0.8 \
  -p 8001:8000 \
  -v $(pwd)/model:/app/model:ro \
  mixtex-ocr-gpu:latest
```

### 调试命令

```bash
# 查看容器状态
docker ps -a

# 查看容器日志
docker logs mixtex-ocr

# 进入容器调试
docker exec -it mixtex-ocr /bin/bash

# 检查健康状态
curl http://localhost:8000/health

# 检查模型加载
curl http://localhost:8000/health | jq
```

### 性能优化

1. **使用 SSD 存储**: 提高模型加载速度
2. **调整资源限制**: 根据实际使用情况调整 CPU/内存
3. **启用缓存**: 使用 Redis 缓存推理结果
4. **负载均衡**: 使用多实例和负载均衡器

## 📝 更新日志

### v1.0.0
- 初始 Docker 支持
- 多架构构建 (amd64/arm64)
- GitHub Actions 自动构建
- 健康检查和安全扫描

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进 Docker 部署配置。

## 📄 许可证

本项目遵循原项目许可证。
