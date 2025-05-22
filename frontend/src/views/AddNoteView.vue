<template>
  <div>
    <!-- Top nav -->
    <nav class="navbar fixed-top">
      <div class="container-fluid d-flex justify-content-between">
        <div class="navbar-brand">Krabbel</div>
        <div>
          <span class="navbar-text me-3">Welcome, {{ username }}</span>
          <button class="btn btn-light btn-sm" @click="logout">Logout</button>
        </div>
      </div>
    </nav>

    <!-- Sidebar -->
    <div class="sidebar">
      <input type="text" class="form-control mb-3" disabled placeholder="Search (disabled here)" />
      <button class="sidebar-btn">Favourites</button>
      <button class="sidebar-btn">Explore</button>
      <router-link to="/add-note" class="sidebar-btn">Add Note</router-link>
    </div>

    <!-- Main content -->
    <div class="main-content">
      <h2>Add Note</h2>

      <form @submit.prevent="addNote">
        <div class="mb-3">
          <label class="form-label">Title</label>
          <input v-model="newNote.title" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Content</label>
          <textarea v-model="newNote.content" class="form-control" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Add Note</button>
      </form>

      <div v-if="errorMessage" class="alert alert-danger mt-3">{{ errorMessage }}</div>
      <div v-if="successMessage" class="alert alert-success mt-3">{{ successMessage }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const newNote = ref({ title: '', content: '' })
const username = ref(localStorage.getItem('username') || 'User')

const errorMessage = ref('')
const successMessage = ref('')

const addNote = async () => {
  errorMessage.value = ''
  successMessage.value = ''

  if (!newNote.value.title.trim() || !newNote.value.content.trim()) {
    errorMessage.value = 'Title and content are required.'
    return
  }

  const token = localStorage.getItem('token')
  if (!token) {
    errorMessage.value = 'Authentication token not found.'
    return
  }

  try {
    await axios.post('/api/notes', newNote.value, {
      headers: { Authorization: `Bearer ${token}` }
    })
    successMessage.value = 'Note added successfully!'
    setTimeout(() => {
      router.push('/notes')
    }, 1000)
  } catch (error) {
    errorMessage.value = 'Failed to add note. Please try again.'
    console.error('Error adding note:', error)
  }
}

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  router.push('/')
}
</script>
