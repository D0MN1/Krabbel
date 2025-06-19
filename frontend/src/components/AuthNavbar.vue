<template>
  <nav class="navbar fixed-top bg-light shadow-sm">
    <div class="container-fluid d-flex justify-content-between">
      <div class="navbar-brand">Krabbel</div>
      <div>
        <span class="navbar-text me-3">Welcome, {{ username }}</span>
        <button class="btn btn-light btn-sm" @click="logout">Logout</button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ref } from 'vue'

const router = useRouter()
const username = ref(localStorage.getItem('username') || 'User')

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  router.push('/')
}
</script>
