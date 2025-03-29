<template>
  <section id="references">       
    <div class="text-content">
      <h2>{{ text.title }}</h2>
      <div class="usa-accordion usa-accordion--bordered">
        <div
          v-for="reference in text.references"
          :key="reference.subTitle"
        >
          <p>
            <span v-html="reference.num" />. <span v-html="reference.authors" /> <a
              :href="reference.link"
              target="_blank"
            ><span v-html="reference.title" /></a><span v-html="reference.ref" />
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import referencesText from '@/assets/text/referencesText'

const text = referencesText.referencesContent
</script>

<style scoped lang="scss">


</style>