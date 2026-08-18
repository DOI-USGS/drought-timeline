<template>
  <section id="authors-container">
    <div class="page-section">
      <!-- HEADING -->
      <h2
        v-if="titleLevel === '2'"
        v-html="authors.title"
      />
      <h3
        v-if="titleLevel === '3'"
        v-html="authors.title"
      />
      <p v-html="formatAuthorText(authors)" />
    </div>
  </section>
</template>

<script setup>
  defineProps({
    titleLevel: {
      type: String,
      default: "3"
    },
    authors: {
      type: Object,
      // Object or array defaults must be returned from
      // a factory function.
      default() {
        return {
          title: "USGS Vizlab",
          authorText: "",
          projectTeam: [],
          leadAuthors: [],
          additionalAuthors: [],
          lastAuthor: []
        }
      }
    }
  })

  function createLink(data) {
    return data.link ? `<a href="${data.link}" target="_blank">${data.name}</a>` : data.name;
  }

  function formatAuthorText(data) {
    // Map placeholders to their replacement text
    const replacements = {
      "{projectTeam}": createLink(data.projectTeam[0]),
      "{leadAuthors}": data.leadAuthors.length > 2 ? `${data.leadAuthors.slice(0, data.leadAuthors.length - 1).map(createLink).join(', ')}, and ${data.leadAuthors.slice(-1).map(createLink)}` : data.leadAuthors.map(createLink).join(' and '),
      "{additionalAuthors}": data.additionalAuthors.map(createLink).join(', '),
      "{lastAuthor}": createLink(data.lastAuthor[0])
    };

    // Replace placeholders in the authorText
    return data.authorText.replace(/{\w+}/g, (match) => {
      return replacements[match] || match; // Return the replacement or the original text if not found
    });
  }
</script>

<style scoped lang="scss">
  /* moved from DroughtHistory.vue when this section was extracted */
  #authors-container {
    height: auto;
  }
  .page-section {
    margin: auto;
    padding: 1em;
    max-width: 1200px;
  }
</style>
