<template>
  <div>
    <div class="main-content">
      <form @submit.prevent="updateNote">
        <div class="mb-3">
          <label for="title" class="form-label">Title</label>
          <input type="text" class="form-control" id="title" v-model="note.title" required>
        </div>
        <div class="mb-3">
          <label for="content" class="form-label">Content</label>
          <textarea v-model="note.content" class="form-control" rows="3" required></textarea>
        </div>
        <div class="mb-3">
          <label for="tags" class="form-label">Tags (comma-separated)</label>
          <input type="text" class="form-control" id="tags" v-model="note.tags">
        </div>
        <div class="mb-3">
          <label for="image" class="form-label">Image URL</label>
          <input type="text" class="form-control" id="image" v-model="note.imageUrl">
        </div>
        <div class="mb-3 form-check">
          <input type="checkbox" class="form-check-input" id="public" v-model="note.isPublic">
          <label class="form-check-label" for="public">Public</label>
        </div>
        <button type="submit" class="btn btn-primary">Update Note</button>
      </form>

      <div v-if="errorMessage" class="alert alert-danger mt-3">{{ errorMessage }}</div>
      <div v-if="successMessage" class="alert alert-success mt-3">{{ successMessage }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const route = useRoute()
const noteId = route.params.id

const note = ref({ title: '', content: '', tags: [], imageUrl: '', isPublic: false })
const errorMessage = ref('')
const successMessage = ref('')

onMounted(async () => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get(`/api/notes/${noteId}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    note.value = response.data
  } catch (error) {
    console.error('Error fetching note:', error)
    errorMessage.value = 'Failed to fetch note. Please try again.'
  }
})

const updateNote = async () => {
  errorMessage.value = ''
  successMessage.value = ''

  if (!note.value.title.trim() || !note.value.content.trim()) {
    errorMessage.value = 'Title and content are required.'
    return
  }

  const token = localStorage.getItem('token')
  if (!token) {
    errorMessage.value = 'Authentication token not found.'
    return
  }

  try {
    const tagsArray = note.value.tags ? note.value.tags.split(',').map(tag => tag.trim()) : [];
    const response = await axios.put(`/api/notes/${noteId}`, {
      title: note.value.title,
      content: note.value.content,
      tags: tagsArray,
      imageUrl: note.value.imageUrl,
      isPublic: note.value.isPublic
    }, {
      headers: { Authorization: `Bearer ${token}` }
    })
    successMessage.value = 'Note updated successfully!'
    router.push('/notes') // Redirect to notes view
  } catch (error) {
    console.error('Error updating note:', error)
    errorMessage.value = 'Failed to update note. Please try again.'
  }
}
</script>