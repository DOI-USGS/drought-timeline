<template>
<section id="main-container">
  <div id="title-container">
    <h2>A history of drought in the western U.S.</h2>
    <nav id="nav-button-container">
      <p>
        <span><button id='button1950s' class="button first">1950s</button></span>
        <span><button id='button1960s' class="button">1960s</button></span>
        <span><button id='button1970s' class="button">1970s</button></span>
        <span><button id='button1980s' class="button">1980s</button></span>
        <span><button id='button1990s' class="button">1990s</button></span>
        <span><button id='button2000s' class="button">2000s</button></span>
        <span><button id='button2010s' class="button">2010s</button></span>
      </p>
    </nav>
  </div>

  <div id="container">
    <div id="annotation-container">
      <div
          v-for="annotation in annotations" 
          :key="annotation.id"
          :class="`droughtText drought-text-${annotation.id}`"
          :style="{top: annotation.offset}"
        >
          <div class="text-container">
            <p :style="{color: annotation.textColor}">{{ annotation.text }}</p>
          </div>
        </div>
    </div>
    <div id="module">
      <img id="swarm_vertical" src="@/assets/images/duration-chart/swarm_jd7d_2_western_compressed_vertical.png" alt="" />
    </div>
  </div>
</div>
</template>
<script>
import { store } from '../store/store.js'
import { isMobile } from 'mobile-device-detect';
import { ScrollTrigger } from "gsap/ScrollTrigger"; // animated scroll events
import { TimelineMax } from "gsap/all";
import droughtAnnotations from "@/assets/text/droughtAnnotations.json";
export default {
  name: "DroughtHistory",
    components: {
    },
    props: {
    },
    data() {
      return {
        publicPath: process.env.BASE_URL, // allows the application to find the files when on different deployment roots
        mobileView: isMobile, // test for mobile
        annotations: JSON.parse(droughtAnnotations),
        // dimensions
        w: store.state.windowWidth,
        h: store.state.windowHeight,
        // margin: { top: 50, right: 50, bottom: 50, left: 50 },

        // show scroll trigger markers on the page?
        marker_on: false,

      }
  },
  mounted(){      
    // register plugins for global use
      this.$gsap.registerPlugin(ScrollTrigger, TimelineMax); 

      // create the scrolling timeline
      let tl = this.$gsap.timeline(); 

      let container = document.getElementById("container");
      console.log(container)
      this.$gsap.to(container, {
        y: () => -(container.scrollHeight - document.documentElement.clientHeight) + "px",
        ease: "none",
        scrollTrigger: {
          trigger: container,
          invalidateOnRefresh: true,
          pin: true,
          scrub: 0,
          end: () => "+=" + container.offsetHeight
        }
      })

    },
    methods:{
      isMobile() {
              if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                  return true
              } else {
                  return false
              }
          }
    }
}
</script>
<style scoped lang="scss">
// handwriting font
@import url('https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap');
$writeFont: 'Nanum Pen Script', cursive;

html,body{
  padding:0;
  margin:0;
}
body {
  overflow-y: hidden;
}
img {
  height: auto;
  width: 100vw;
}
#container {
  display: flex;
  flex-wrap: wrap;
  flex-direction:column;
  width: 100vw;
}
#swarm_vertical {
  transform: rotate(180deg)
}
.droughtText {
  z-index: 10;
  position: absolute;
  p {
    // color: black;
  }

}
#title-container {
  display: block;
  width: 100vw;
}
#nav-button-container {
  padding: 10px 0px 10px 0px;
}
.button {
  padding: 3px 6px 4px 5px;
  margin-left: 5px;
  @media only screen and (max-width: 600px) {
    margin-left: 1px;
  }
}
.button.first {
  margin-left: 0px;
}
.button:hover {
  background-color: black;
  color: white;
  border-radius: 3px;
}
</style>