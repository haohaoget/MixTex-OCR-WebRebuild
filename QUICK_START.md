# 🚀 快速开始指南

本指南帮助您快速部署 MixTex-OCR-WebRebuild 项目。

## 📋 前置要求

- Docker 20.10+ (支持 Buildx)
- Docker Compose (可选)
- Git

## ⚡ 一键部署

### 方式一：使用预构建镜像（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/haohaoget/MixTex-OCR-WebRebuild.git
cd MixTex-OCR-WebRebuild

# 2. 下载模型文件到 model 目录
# 从 Releases 页面下载模型文件并解压到 model/ 目录

# 3. 运行容器
docker run -d \
  --name mixtex-ocr \
  --restart unless-stopped \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest

# 4. 访问服务
echo "访问 http://localhost:8000"
```

### 方式二：使用 Docker Compose

```bash
# 1. 克隆项目
git clone https://github.com/haohaoget/MixTex-OCR-WebRebuild.git
cd MixTex-OCR-WebRebuild

# 2. 下载模型文件
# 从 Releases 页面下载模型文件并解压到 model/ 目录

# 3. 启动服务
docker-compose up -d

# 4. 查看状态
docker-compose ps

# 5. 查看日志
docker-compose logs -f
```

### 方式三：使用 GPU 加速（需要 NVIDIA GPU）

```bash
# 1. 确保安装了 NVIDIA Docker Runtime
# 安装指南: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

# 2. 启动 GPU 版本
docker-compose --profile gpu up -d

# 3. 访问 GPU 版本服务
echo "访问 http://localhost:8001"
```

## 🔧 本地构建

如果您想自己构建镜像：

```bash
# 1. 构建镜像
docker build -t mixtex-ocr .

# 2. 运行容器
docker run -d \
  --name mixtex-ocr \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  mixtex-ocr
```

## 🏗️ 多架构构建

如果您需要构建多架构镜像：

```bash
# 1. 设置 Buildx
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap

# 2. 构建多架构镜像
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag mixtex-ocr:latest \
  --push .
```

## 📁 模型文件设置

1. 访问项目的 [Releases 页面](https://github.com/haohaoget/MixTex-OCR-WebRebuild/releases)
2. 下载最新的模型文件压缩包
3. 解压到项目的 `model/` 目录

确保 `model/` 目录包含以下文件：
- `encoder_model.onnx`
- `decoder_model_merged.onnx`
- `tokenizer.json`
- `vocab.json`

## 🌐 访问服务

部署成功后，您可以通过以下方式访问：

- **Web 界面**: http://localhost:8000 (CPU版本) 或 http://localhost:8001 (GPU版本)
- **API 文档**: http://localhost:8000/docs
- **健康检查**: http://localhost:8000/health

### 前端功能
- 🖼️ 图片上传识别
- 📋 剪贴板粘贴识别
- 🔄 实时LaTeX预览
- 📤 结果复制和导出
- 📊 识别历史记录

## 📊 验证部署

```bash
# 检查容器状态
docker ps

# 检查健康状态
curl http://localhost:8000/health

# 查看日志
docker logs mixtex-ocr
```

## 🔍 故障排除

### 常见问题

1. **模型文件未找到**
   ```bash
   # 检查模型文件
   ls -la model/
   docker exec mixtex-ocr ls -la /app/model/
   ```

2. **端口冲突**
   ```bash
   # 使用不同端口
   docker run -d -p 8080:8000 mixtex-ocr
   ```

3. **内存不足**
   ```bash
   # 增加内存限制
   docker run -d --memory=4g mixtex-ocr
   ```

### 获取帮助

- 查看 [DOCKER_DEPLOYMENT.md](./DOCKER_DEPLOYMENT.md) 获取详细文档
- 提交 [Issue](https://github.com/haohaoget/MixTex-OCR-WebRebuild/issues)

## 🎯 下一步

- 配置 Nginx 反向代理
- 设置 HTTPS
- 配置监控和日志
- 部署到 Kubernetes

## 📝 更新服务

```bash
# 1. 停止旧容器
docker stop mixtex-ocr
docker rm mixtex-ocr

# 2. 拉取新镜像
docker pull ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest

# 3. 启动新容器
docker run -d \
  --name mixtex-ocr \
  --restart unless-stopped \
  -p 8000:8000 \
  -v $(pwd)/model:/app/model:ro \
  ghcr.io/haohaoget/mixtex-ocr-webrebuild:latest
```

---

🎉 **恭喜！您已经成功部署了 MixTex-OCR-WebRebuild 服务！**
