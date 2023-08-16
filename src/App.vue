<template>
  <div id="app">
    <WindowSize v-if="checkTypeOfEnv === '-test build-'" />
    <HeaderUSGS
      ref="headerUSGS"
    />
    <InternetExplorerPage v-if="isInternetExplorer" />
    <!-- an empty string in this case means the 'prod' version of the application   -->
    <router-view
      v-if="!isInternetExplorer"
    /> 
    <PreFooterCodeLinks v-if="!isInternetExplorer" />
    <!-- PreFooterVisualizationsLinks v-if="!isInternetExplorer" / -->
    <FooterUSGS />
  </div>
</template>

<script>
    import WindowSize from "./components/WindowSize";
    import HeaderUSGS from './components/HeaderUSGS';
    import { isMobile } from 'mobile-device-detect';
    export default {
        name: 'App',
        components: {
            WindowSize,
            HeaderUSGS,
            InternetExplorerPage: () => import( /* webpackPrefetch: true */ /*webpackChunkName: "internet-explorer-page"*/ "./components/InternetExplorerPage"),
            // PreFooterVisualizationsLinks: () => import( /* webpackPreload: true */ /*webpackChunkName: "pre-footer-links-visualizations"*/ "./components/PreFooterVisualizationsLinks"),
            PreFooterCodeLinks: () => import( /* webpackPrefetch: true */ /*webpackChunkName: "pre-footer-links-code"*/ "./components/PreFooterCodeLinks"),
            FooterUSGS: () => import( /* webpackPrefetch: true */ /*webpackChunkName: "usgs-footer"*/ "./components/FooterUSGS") // Have Webpack put the footer in a separate chunk so we can load it conditionally (with a v-if) if we desire
        },
        data() {
            return {
                isInternetExplorer: false,
                title: process.env.VUE_APP_TITLE,
                publicPath: process.env.BASE_URL, // this is need for the data files in the public folder
                mobileView: isMobile,
            }
        },
        computed: {
          checkTypeOfEnv() {
              return process.env.VUE_APP_TIER
          },
          windowWidth: function() {
            return this.$store.state.windowWidth
          },
          windowHeight: function () {
              return this.$store.state.windowHeight
          }
        },
        mounted(){
       
        },
        created() {
            // We do not support for Internet Explorer. This tests if the browser used is IE.
            this.$browserDetect.isIE ? this.isInternetExplorer = true : this.isInternetExplorer = false;
            // Add window size tracking by adding a listener and a way to store the values in the Vuex state
            window.addEventListener('resize', this.handleResize);
            this.handleResize();
        },
        destroyed() {
            window.removeEventListener('resize', this.handleResize);
        },
        methods:{
          handleResize() {
                this.$store.commit('recordWindowWidth', window.innerWidth);
                this.$store.commit('recordWindowHeight', window.innerHeight);
            },
        }
    }
</script>

<style lang="scss">
// Fonts
@import url('https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@200;300;400;500;600;700;800&display=swap');
$SourceSans: 'Source Sans Pro', sans-serif;
$textcolor: #333534;
@import url('https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap');
$writeFont: 'Nanum Pen Script', cursive;
// whole page except header fit within viewport - no scrolling
#app {
  width: 100%;
  height: calc(100vh + 85.7px); //85.7 is the height of the USGS header
}

// Type
html,
:root {
  font-size: 62.5%;
}
body {
      height: 100%;
      background-color: white;
      margin: 0;
      padding: 0;
      line-height: 1.2;
      font-size: 2rem;
      font-weight: 400;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      width: 100%;
      @media screen and (max-width: 600px) {
        font-size: 1.6rem;
      }
  }
h1{
  font-size: 4.5rem;
  font-weight: 500;
  font-family: $SourceSans;
  line-height: 1;
  text-align: left;
  text-shadow: 1px 1px 100px rgba(0,0,0,.8);
    color: $textcolor;
  @media screen and (max-width: 600px) {
    font-size: 4.75rem;
  }
}
h2{
  font-weight: 700;
  text-align: left;
  font-family: $SourceSans;
  font-size: 6rem;
  margin-top: 5px;
  line-height: 1.2;
  color: $textcolor;
  @media screen and (max-width: 600px) {
    font-size: 4rem;
  }
}
h3{
  font-size: 3.5rem;
  padding-top: 1em;
  padding-bottom: .25em;
  font-family: $SourceSans;
  font-weight: 700;
  color: $textcolor;
  @media screen and (max-width: 600px) {
      font-size: 3.2rem;
  }  
}
h4{
  font-size: 2.5rem;
  padding-top: 0em;
  padding-bottom: .25em;
  font-family: $SourceSans;
  font-weight: 600;
  color: $textcolor;
  @media screen and (max-width: 600px) {
    font-size: 1.8rem;
  }  
}
p, text {
  // padding: 1em 0 0 0; 
  font-family: $SourceSans;
  color: $textcolor;
}
.droughtText.notesText{
  font-family: $writeFont;
  font-size: 2.5rem;
}
input[type=button] {
        font-family: $SourceSans;
    }

// General Layout  
  .text-content {
    min-width: 300px;
    max-width: 700px;
    margin: 0 auto;
    padding: 10px;   
    @media screen and (max-width: 600px) {
        padding: 10px;
    }  
  }
  .flex-container {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;
    justify-content: space-evenly;
    align-content: space-around;
    max-width: 30%;
    margin: auto;
    @media screen and (max-width: 600px) {
        max-width: 100%;
    }
  }
  .flex-item {
    padding: 20px;
    min-width: 400px;
    flex: 0 0 auto;
    align-self: center;
  }
  @media (max-width: 600px) {
    .flex-container {
      flex-direction: column;
    }
    .flex-item {
      flex: none;
      padding: 0 0 1em 0;
      height: 100%;
    }
  }
  .figure-content {
    border: 1px white;
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;
    justify-content: space-evenly;
    align-content: space-around;
    max-width: 100%;
    margin: auto;
    @media screen and (max-width: 600px) {
        padding: 0px; 
    }
  }

.legend-text {
    fill: black;
    font-family: $SourceSans;
    font-size: 1.6rem;
  }
.viz-comment {
  font-family: $SourceSans;
  font-size: 2.6rem;
  font-weight: 400;
  fill:rgb(224, 222, 222);
}
.viz-emph {
  font-weight:700;
  fill: white;
  font-family: $SourceSans;
  font-size: 2.6rem;
}
.emph {
  font-weight: bold;
}
.italic {
  font-style: italic;
}
.pseudo-caption {
  font-size: 1.0rem;
  margin: 0 10px;
}
// Link Styling

sup {
  opacity: .4;
}
.sticky-header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
}

</style>
