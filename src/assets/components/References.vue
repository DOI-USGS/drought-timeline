<template>
  <section id="references">       
    <div class="text-content">
      <h2>{{ text.title }}</h2>
      <div>
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
  
  <script>
      import referencesText from "@/assets/text/referencesText";
      export default {
          name: 'References',
          data() {
              return {
                  text: referencesText.referencesContent
              }
          }
      }
  </script>
  /*Scope USWDS styles*/
  <style scoped src="../../node_modules/uswds/dist/css/uswds.min.css"></style>
  <style scoped lang="scss">
  </style>