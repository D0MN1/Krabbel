<template>
  <div>
    <!-- ✍️ Intro animatie -->
    <div v-if="showIntro" class="intro">
      <svg viewBox="0 0 800 200" class="krabbel-svg">
        <text x="50" y="130" class="krabbel-text">Krabbel</text>
      </svg>
      <img src="/pen.png" alt="Pen" class="pen" />
    </div>

    <!-- 🏠 Main homepage -->
    <transition name="fade">
      <div v-if="showContent" class="container text-center mt-5">
        <h1>Welcome to Krabbel</h1>
        <p class="lead">Keep your thoughts organized and accessible. "Van wazig naar wauw"</p>
        <router-link to="/login" class="btn btn-primary mt-3">Login</router-link>

        <!-- Cards met scroll animatie -->
        <div class="row mt-5">
          <div class="col-md-6 mb-4">
            <div class="info-card" v-scroll-fade>
              <h4>📝 Maak notities snel</h4>
              <p>Gebruik Krabbel om je gedachten snel vast te leggen. Voeg titels en inhoud toe, en bewaar ze veilig.</p>
            </div>
          </div>
          <div class="col-md-6 mb-4">
            <div class="info-card" v-scroll-fade>
              <h4>🔍 Zoek en beheer</h4>
              <p>Vind notities makkelijk terug via zoekfilters. Verwijder wat je niet meer nodig hebt.</p>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// Intro zichtbaar
const showIntro = ref(true)
const showContent = ref(false)

onMounted(() => {
  setTimeout(() => {
    showIntro.value = false
    showContent.value = true
  }, 3500) // tijd voor animatie
})
</script>

<style scoped>
/* Pen schrijf animatie */
.krabbel-svg {
  width: 100%;
  height: 200px;
}
.krabbel-text {
  font-size: 72px;
  font-weight: bold;
  fill: none;
  stroke: black;
  stroke-width: 2;
  stroke-dasharray: 700;
  stroke-dashoffset: 700;
  animation: draw 3s ease forwards;
}
.pen {
  width: 60px;
  position: absolute;
  top: 120px;
  left: 150px;
  animation: pen-move 3s ease forwards;
}
@keyframes draw {
  to {
    stroke-dashoffset: 0;
  }
}
@keyframes pen-move {
  0% { left: 50px; opacity: 1; }
  90% { left: 580px; opacity: 1; }
  100% { opacity: 0; }
}
.intro {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  background: white;
  z-index: 10;
}

/* Fade transition */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

/* Cards */
.info-card {
  background: #f8f9fa;
  padding: 30px;
  border-radius: 16px;
  box-shadow: 0 8px 16px rgba(0,0,0,0.05);
  transform: translateY(30px);
  opacity: 0;
  transition: all 0.6s ease;
}
.info-card.show {
  transform: translateY(0);
  opacity: 1;
}
</style>

<script>
// 👀 Scroll fade directive
import { onMounted } from 'vue'

export default {
  directives: {
    scrollFade: {
      mounted(el) {
        const observer = new IntersectionObserver(
          ([entry]) => {
            if (entry.isIntersecting) {
              el.classList.add('show')
              observer.unobserve(el)
            }
          },
          { threshold: 0.1 }
        )
        observer.observe(el)
      }
    }
  }
}
</script>
