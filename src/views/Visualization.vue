<template>
  <div id="visualization">
    <DroughtHistory />

  </div>
</template>

<script>

export default {
    name: 'Visualization',
    components: {
      DroughtHistory: () => import( /* webpackPreload: true */ /*webpackChunkName: "section"*/ "./../components/DroughtHistory"),
     //References: () => import( /*webpackChunkName: "References"*/ "./../components/References")
    },
    computed: {
    },
    mounted(){
    },
    methods:{
    }
} 
</script>

<style lang="scss">
#visualization {
  //height: calc(100vh);
  height: 100vh;
  position: relative;
  top: 0;

}

</style>
