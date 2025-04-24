import { createApp } from 'vue'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.bundle.min.js'
import './style.css'
import App from './App.vue'
import router from './router'
import axios from 'axios'

// Configure axios
// Remove baseURL since we're using Vite proxy
// axios.defaults.baseURL = 'http://localhost:8081'

// Add request interceptor to add JWT token to headers
axios.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// Add response interceptor to handle authentication errors
axios.interceptors.response.use(
  response => response,
  error => {
    if (error.response && error.response.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('username')
      router.push('/')
    }
    return Promise.reject(error)
  }
)

const app = createApp(App)

app.use(router)

app.mount('#app')
