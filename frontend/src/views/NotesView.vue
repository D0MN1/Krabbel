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
      <input type="text" v-model="searchQuery" class="form-control mb-3" placeholder="Search notes..." />
      <button class="sidebar-btn">Favourites</button>
      <button class="sidebar-btn">Explore</button>
      <router-link to="/add-note" class="sidebar-btn">Add Note</router-link>
    </div>

    <!-- Main content -->
    <div class="main-content">
      <h2>My Notes</h2>

      <div v-if="loading" class="text-center"><span class="spinner-border"></span></div>

      <div v-else>
        <div v-if="filteredNotes.length === 0" class="alert alert-info">No notes found.</div>

        <div class="row">
          <div v-for="note in filteredNotes" :key="note.id" class="col-md-4 mb-4">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title">{{ note.title }}</h5>
                <p class="card-text">{{ note.content }}</p>
                <button class="btn btn-sm btn-danger" @click="deleteNote(note.id)">Delete</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const route = useRoute()

const notes = ref([])
const loading = ref(true)
const username = ref(localStorage.getItem('username') || 'User')
const searchQuery = ref('')

const fetchNotes = async () => {
  try {
    loading.value = true
    const token = localStorage.getItem('token')
    console.log('⏳ Fetching notes with token:', token)

    const response = await axios.get('/api/notes', {
      headers: { Authorization: `Bearer ${token}` }
    })

    console.log('✅ Notes fetched:', response.data)
    notes.value = response.data
  } catch (error) {
    console.error('❌ Error fetching notes:', error)
    if (error.response?.status === 401) logout()
  } finally {
    loading.value = false
  }
}


const filteredNotes = computed(() => {
  const q = searchQuery.value.toLowerCase()
  return notes.value.filter(note =>
    note.title.toLowerCase().includes(q) || note.content.toLowerCase().includes(q)
  )
})

const deleteNote = async (id) => {
  try {
    const token = localStorage.getItem('token')
    await axios.delete(`/api/notes/${id}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    fetchNotes()
  } catch (error) {
    console.error('Error deleting note:', error)
  }
}

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  router.push('/')
}

// 🔄 Trigger fetchNotes bij navigatie terug naar deze view
watch(() => route.fullPath, () => {
  fetchNotes()
})

onMounted(() => {
  if (!localStorage.getItem('token')) {
    router.push('/')
  } else {
    fetchNotes()
  }
})
</script>
