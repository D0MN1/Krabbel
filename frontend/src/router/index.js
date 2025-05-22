import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import NotesView from '../views/NotesView.vue'
import AddNoteView from '../views/AddNoteView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/notes',
      name: 'notes',
      component: NotesView,
      meta: { requiresAuth: true }
    },
    {
  path: '/add-note',
  name: 'AddNote',
  component: () => import('../views/AddNoteView.vue')

}
  ]
})

router.beforeEach((to, from, next) => {
  const publicPages = ['login', 'home']
  const authRequired = !publicPages.includes(to.name) && to.meta.requiresAuth
  const token = localStorage.getItem('token')

  if (authRequired && !token) {
    return next({ name: 'login' })
  }

  // Als je al bent ingelogd, en je gaat naar / of /login, redirect naar /notes
  if (token && (to.name === 'login' || to.name === 'home')) {
    return next({ name: 'notes' })
  }

  next()
})


export default router
