<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'


const podName = import.meta.env.VITE_HOSTNAME ? import.meta.env.VITE_HOSTNAME : 'unknown';
let apiPod = ref(null);
let isReady = ref(null);

onMounted(async () => {
    try {
        isReady.value = false;
        await axios
          .get(import.meta.env.VITE_API_URL)
          .then(response => {
            apiPod.value = response['data']['pod_name'];
            console.log(apiPod);
          })
    } catch(e) {
        console.log(e);
        apiPod.value = 'unavailable';
    }
    finally {
        isReady.value = true;
    }
});
defineProps({
  msg: {
    type: String,
    required: true
  }
})
</script>

<template>
    <div class="centered">
      <h1>{{ msg }}</h1>
      <h2>The name of this pod is {{ podName }}</h2>
      <h2 v-if="isReady">The name of the API pod is {{ apiPod }}</h2>
    </div>
</template>

<style scoped>
.centered {
    margin: auto;
    width: 50%;
    text-align: center;
}
</style>