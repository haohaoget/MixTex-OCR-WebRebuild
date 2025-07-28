<template>
  <transition name="fade">
    <div v-if="visible" class="about-popup-overlay" @click.self="close">
      <div class="about-popup-container">
        <div class="about-popup-header">
          <h2>关于 MixTeX OCR</h2>
          <button class="close-button" @click="close">&times;</button>
        </div>
        <div class="about-popup-content">
          <h3>MixTeX OCR 网页版</h3>
          <!-- <p><strong>主要功能：</strong></p>
          <ul>
            <li>📋 剪贴板图片粘贴识别</li>
            <li>🔄 自动识别处理</li>
            <li>📝 实时结果预览</li>
            <li>📋 一键复制结果</li>
          </ul> -->
          <p><strong>技术栈：</strong></p>
          <ul>
            <li>前端：Vue 3 + Element Plus</li>
            <li>后端：FastAPI</li>
            <li>模型：MixTeX 模型</li>
          </ul>
          <p><strong>网站版重构者：Hipeace</strong></p>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref } from 'vue';

// 响应式状态
const visible = ref(false);

// 显示弹窗
const show = () => {
  visible.value = true;
};

// 关闭弹窗
const close = () => {
  visible.value = false;
};

// 暴露方法给外部使用
defineExpose({
  show,
  close
});
</script>

<style scoped>
.about-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  /* 不影响滚动条 */
  pointer-events: auto;
}

.about-popup-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.about-popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #ebeef5;
}

.about-popup-header h2 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.close-button {
  background: none;
  border: none;
  font-size: 22px;
  color: #909399;
  cursor: pointer;
}

.close-button:hover {
  color: #409eff;
}

.about-popup-content {
  padding: 20px;
  overflow-y: auto;
}

.about-popup-content h3 {
  margin-top: 0;
  color: #303133;
}

.about-popup-content ul {
  padding-left: 20px;
}

.about-popup-content li {
  margin-bottom: 8px;
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>