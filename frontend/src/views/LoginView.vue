<template>
  <div class="container mt-5">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card">
          <div class="card-header">
            <h3 class="text-center">Login</h3>
          </div>
          <div class="card-body">
            <div v-if="errorMessage" class="alert alert-danger">
              {{ errorMessage }}
            </div>
            <form @submit.prevent="handleLogin">
              <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input
                  type="text"
                  class="form-control"
                  id="username"
                  v-model="username"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input
                  type="password"
                  class="form-control"
                  id="password"
                  v-model="password"
                  required
                />
              </div>
              <div class="d-grid">
                <button type="submit" class="btn btn-primary">Login</button>
              </div>
            </form>
            <div class="mt-3 text-center">
              <small>Use username: <strong>user</strong> and password: <strong>user123</strong> to login</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const username = ref('')
const password = ref('')
const errorMessage = ref('')

const handleLogin = async () => {
  try {
    errorMessage.value = ''
    console.log('Attempting login with:', username.value, password.value)
    
    const response = await axios.post('/api/auth/login', {
      username: username.value,
      password: password.value
    })
    
    console.log('Login response:', response.data)
    
    if (response.data.token) {
      localStorage.setItem('token', response.data.token)
      localStorage.setItem('username', response.data.username)
      router.push('/notes')
    }
  } catch (error) {
    console.error('Login failed:', error)
    errorMessage.value = 'Login failed. Please check your credentials.'
  }
}
</script>

<style scoped>
.card {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style> 