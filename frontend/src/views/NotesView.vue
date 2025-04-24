<template>
  <div class="container mt-4">
    <div class="row">
      <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2>My Notes</h2>
          <div>
            <span class="me-3">Welcome, {{ username || 'User' }}</span>
            <button class="btn btn-outline-danger" @click="logout">Logout</button>
          </div>
        </div>
        <div class="card mb-4">
          <div class="card-body">
            <form @submit.prevent="addNote">
              <div class="mb-3">
                <label for="title" class="form-label">Title</label>
                <input
                  type="text"
                  class="form-control"
                  id="title"
                  v-model="newNote.title"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="content" class="form-label">Content</label>
                <textarea
                  class="form-control"
                  id="content"
                  v-model="newNote.content"
                  rows="3"
                  required
                ></textarea>
              </div>
              <button type="submit" class="btn btn-primary">Add Note</button>
            </form>
          </div>
        </div>

        <div v-if="loading" class="text-center my-4">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>

        <div v-else-if="notes.length === 0" class="alert alert-info text-center my-4">
          You don't have any notes yet. Create your first note above!
        </div>

        <div v-else class="row">
          <div
            v-for="note in notes"
            :key="note.id"
            class="col-md-4 mb-4"
          >
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title">{{ note.title }}</h5>
                <p class="card-text">{{ note.content }}</p>
                <div class="d-flex justify-content-end">
                  <button
                    class="btn btn-sm btn-primary me-2"
                    @click="editNote(note)"
                  >
                    Edit
                  </button>
                  <button
                    class="btn btn-danger btn-sm"
                    @click="deleteNote(note.id)"
                  >
                    Delete
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const notes = ref([])
const loading = ref(true)
const username = ref(localStorage.getItem('username') || '')
const newNote = ref({
  title: '',
  content: ''
})

const fetchNotes = async () => {
  try {
    loading.value = true
    const token = localStorage.getItem('token')
    const response = await axios.get('/api/notes', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    notes.value = response.data
    loading.value = false
  } catch (error) {
    console.error('Error fetching notes:', error)
    if (error.response && error.response.status === 401) {
      logout()
    }
    loading.value = false
  }
}

const addNote = async () => {
  try {
    const token = localStorage.getItem('token')
    await axios.post('/api/notes', newNote.value, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    newNote.value = { title: '', content: '' }
    fetchNotes()
  } catch (error) {
    console.error('Error adding note:', error)
  }
}

const editNote = async (note) => {
  try {
    // Simple implementation just updates title/content with prompt dialogs
    const newTitle = prompt('Enter new title', note.title)
    const newContent = prompt('Enter new content', note.content)
    
    if (newTitle && newContent) {
      const token = localStorage.getItem('token')
      await axios.put(`/api/notes/${note.id}`, 
        { title: newTitle, content: newContent },
        {
          headers: {
            Authorization: `Bearer ${token}`
          }
        }
      )
      fetchNotes()
    }
  } catch (error) {
    console.error('Error updating note:', error)
  }
}

const deleteNote = async (id) => {
  try {
    const token = localStorage.getItem('token')
    await axios.delete(`/api/notes/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
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

onMounted(() => {
  if (!localStorage.getItem('token')) {
    router.push('/')
    return
  }
  fetchNotes()
})
</script>

<style scoped>
.card {
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style> 