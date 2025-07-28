<template>
  <transition name="fade">
    <div v-if="visible" class="global-loading-overlay">
      <div class="loading-container">
        <div class="loading-letters">
          <span class="letter">M</span>
          <span class="letter">i</span>
          <span class="letter">x</span>
          <span class="letter">T</span>
          <span class="letter">e</span>
          <span class="letter">X</span>
        </div>
        <div class="loading-text">{{ text }}</div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref } from 'vue';

// 响应式状态
const visible = ref(false);
const text = ref('正在识别...');

// 显示加载状态
const show = (message = '正在识别...') => {
  text.value = message;
  visible.value = true;
};

// 隐藏加载状态
const hide = () => {
  visible.value = false;
};

// 暴露方法给外部使用
defineExpose({
  show,
  hide
});
</script>

<style scoped>
.global-loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  padding: 30px 40px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.loading-letters {
  margin-bottom: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.letter {
  display: inline-block;
  font-size: 36px;
  font-weight: bold;
  color: #409eff;
  margin: 0 2px;
}

.letter:nth-child(1) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0s; }
.letter:nth-child(2) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0.15s; }
.letter:nth-child(3) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0.3s; }
.letter:nth-child(4) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0.45s; }
.letter:nth-child(5) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0.6s; }
.letter:nth-child(6) { animation: jump 0.9s ease-in-out infinite; animation-delay: 0.75s; }

.loading-text {
  font-size: 18px;
  color: #333;
  font-weight: 500;
}

@keyframes jump {
  0% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
  100% { transform: translateY(0); }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>