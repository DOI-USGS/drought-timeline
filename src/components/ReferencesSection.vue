<template>
  <section id="references-container">
    <div class="page-section">
      <!-- HEADING -->
      <h2
        v-if="titleLevel === '2'"
        v-html="references.title"
      />
      <h3
        v-if="titleLevel === '3'"
        v-html="references.title"
      />
      <div>
        <div
          v-for="reference in references.references"
          :key="reference.link"
          class="references-list"
        >
          <p>
            <span v-html="reference.authors" /><span v-if="reference.year"> (<span v-html="reference.year" />)</span>. <a
              :href="reference.link"
              target="_blank"
            ><span v-html="reference.title" /></a><span v-if="reference.data_release">: U.S. Geological Survey data release</span>.
            <span v-if="reference.journal">
              <span
                class="journal-name"
                v-html="reference.journal_name"
              />
              <span v-if="reference.journal_issue">, {{ reference.journal_issue }}</span>.
            </span>
            <span
              v-if="reference.doi"
              v-html="reference.doi"
            />
            <span
              v-else
              v-html="reference.link"
            />
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
  defineProps({
    titleLevel: {
      type: String,
      default: "3"
    },
    references: {
      type: Object,
      // Object or array defaults must be returned from
      // a factory function.
      default() {
        return {
          title: "References",
          references: []
        }
      }
    }
  })
</script>

<style scoped lang="scss">
  /* moved from DroughtHistory.vue when this section was extracted */
  #references-container {
    height: auto;
  }
  .page-section {
    margin: auto;
    padding: 1em;
    max-width: 1200px;
  }
  .references-list {
    padding-left: 42px;
    padding-top: 7px;
    padding-bottom: 7px;
    margin-top: 5px;
    text-indent: -22px;
    overflow-wrap: break-word;
    word-wrap: break-word;
    -ms-word-break: break-all;
    word-break: break-word;
  }
  .journal-name {
    font-style: italic;
  }
</style>
