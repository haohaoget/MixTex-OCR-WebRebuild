# MixTex-OCR-网站版

本项目由[MixTeX-Latex-OCR](https://github.com/RQLuo/MixTeX-Latex-OCR)修改而来，将原本的应用程序重构成了网站，功能基本上不变，模型用的原模型。（我只是个搬运工，再次感谢原作者）

前端使用vue，后端使用Fastapi（对这俩都不太熟，只是感觉开发比较快，代码健壮性可能有很大问题 @_ @ ）

没有用到数据库，因为感觉持久化没啥意义。（个人使用场景下，用不到）

前端界面截图：

![image-20250728162401843](https://picture-typora.obs.cn-north-4.myhuaweicloud.com/images/image-20250728162401843.png)

（非常简陋的界面）感谢Claude     :   )

## 项目结构

```
├── model/                # 模型文件目录
│   ├── encoder_model.onnx       # 编码器模型
│   ├── decoder_model_merged.onnx # 解码器模型
│   ├── tokenizer.json           # 分词器配置
│   └── ...                      # 其他模型文件
├── web-frontend/        # 前端项目
│   ├── src/                     # 源代码
│   ├── package.json             # 前端依赖配置
│   └── ...                      # 其他前端文件
└── webapi/              # 后端API
    ├── app.py                   # FastAPI应用
    └── ...                      # 其他后端文件
```

## 环境要求

### 后端环境

- Python 3.8+
- ONNX Runtime
- FastAPI
- Uvicorn
- Transformers
- Pillow
- 其他依赖（见requirements.txt）

### 前端环境

- Node.js 16+
- npm 或 yarn
- Vue 3
- Element Plus
- Axios

## 安装步骤

### 1. 克隆项目

```bash
git clone <项目仓库URL>
cd web-ocr-math
```

### 2. 安装后端依赖

```bash
cd webapi
pip install -r requirements.txt
```

### 3. 安装前端依赖

```bash
cd ../web-frontend
npm install
```

### 4. 准备模型文件

Model文件我以压缩包的形式放到了Releases下面。

确保在`model`目录中包含以下文件：
- encoder_model.onnx
- decoder_model_merged.onnx
- tokenizer.json
- vocab.json
- 其他必要的模型配置文件

## 运行项目

### 1. 启动后端服务

```bash
cd webapi
uvicorn app:app --host 127.0.0.1 --port 8000 --reload
```

### 2. 启动前端开发服务器

```bash
cd ../web-frontend
npm run dev
```

前端将在 http://localhost:5173 启动，后端API将在 http://localhost:8000 提供服务。



## API接口说明

- `GET /`: API健康检查
- `GET /health`: 模型加载状态检查
- `POST /predict`: 上传图片识别数学公式
- `POST /predict_base64`: 使用Base64编码图片识别数学公式
- `POST /predict_clipboard`: 处理剪贴板图片识别数学公式
- `POST /feedback`: 提交反馈（没什么用）
- `GET /statistics`: 获取使用统计（前端给删了）
- `POST /reload_model`: 重新加载模型



## 补充

1. 可能存在部分BUG没有测试出来，如果存在问题还请提个Issue

2. 大概率不会再修改代码了，~~凑合用~~

3. 如果有任何不严谨的地方，请联系我：hopeace@protonmail.com
