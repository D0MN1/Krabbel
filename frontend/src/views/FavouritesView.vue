<template>
  <div class="container mt-5 pt-5">
    <h2>Favourites</h2>
    <div v-if="favourites.length === 0">No favourite notes.</div>
    <div v-else>
      <div v-for="note in favourites" :key="note.id" class="card mb-3">
        <div class="card-body">
          <h5 class="card-title">{{ note.title }}</h5>
          <p class="card-text">{{ note.content }}</p>
          <p class="card-text">
            <small class="text-muted">
              {{ formatDate(note.created_at || note.updated_at) }}
            </small>
          </p>
          <router-link :to="`/edit-note/${note.id}`" class="btn btn-sm btn-outline-primary">Edit</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const favourites = ref([])

const fetchFavourites = async () => {
  const token = localStorage.getItem('token')
  const { data } = await axios.get('/api/notes', {
    headers: { Authorization: `Bearer ${token}` }
  })
  favourites.value = data.filter(note => note.favourite && !note.archived)
}

const formatDate = (dateStr) => {
  const date = new Date(dateStr)
  return date.toLocaleString()
}

onMounted(fetchFavourites)
</script>
