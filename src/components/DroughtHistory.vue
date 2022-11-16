<template>
<section id="main-container">
  <section id="grid-container">
    <div id="title-container">
      <h2>A history of drought in the western U.S.</h2>
    </div>
    <nav id="nav-button-container">
      <p>
        <span><button id='button-1950s' class="button first" @click="scrollTimeline">1950s</button></span>
        <span><button id='button-1960s' class="button" @click="scrollTimeline">1960s</button></span>
        <span><button id='button-1970s' class="button" @click="scrollTimeline">1970s</button></span>
        <span><button id='button-1980s' class="button" @click="scrollTimeline">1980s</button></span>
        <span><button id='button-1990s' class="button" @click="scrollTimeline">1990s</button></span>
        <span><button id='button-2000s' class="button" @click="scrollTimeline">2000s</button></span>
        <span><button id='button-2010s' class="button" @click="scrollTimeline">2010s</button></span>
      </p>
    </nav>
    <div id="chart-container">
      <img id="swarm_vertical" src="@/assets/images/duration-chart/swarm_jd7d_2_western_compressed_vertical.png" alt=""/>
    </div>
    <div id="chart-overlay">
      <svg id="svg-chart"/>
    </div>
  </section>
  <div id="annotation-container" v-if="mobileView">
    <div
        v-for="annotation in annotations" 
        :key="annotation.id"
        :class="`droughtText drought-text-${annotation.id}`"
      >
        <p>{{ annotation.text }}</p>
      </div>
  </div>
  
</section>
</template>
<script>
import * as d3Base from 'd3';
import { store } from '../store/store.js'
import { isMobile } from 'mobile-device-detect';
import { ScrollTrigger } from "gsap/ScrollTrigger"; // animated scroll events
import { TimelineMax } from "gsap/all";
import { ScrollToPlugin } from "gsap/ScrollToPlugin";
import droughtAnnotations from "@/assets/text/droughtAnnotations.js";
export default {
  name: "DroughtHistory",
    components: {
    },
    props: {
    },
    data() {
      return {
        d3: null,
        publicPath: process.env.BASE_URL, // allows the application to find the files when on different deployment roots
        mobileView: isMobile, // test for mobile
        annotations: JSON.parse(droughtAnnotations),
        // dimensions
        chartWidth: null,
        chartHeight: null,
        // show scroll trigger markers on the page?
        marker_on: false,

      }
  },
  mounted(){      
    this.d3 = Object.assign(d3Base);
    // register plugins for global use
    this.$gsap.registerPlugin(ScrollTrigger, TimelineMax, ScrollToPlugin); 

    // create the scrolling timeline
    let tl = this.$gsap.timeline(); 

    let container = document.getElementById("chart-container");
    console.log(container)
    // this.$gsap.to(container, {
    //   y: () => -(container.scrollHeight - document.documentElement.clientHeight) + "px",
    //   ease: "none",
    //   scrollTrigger: {
    //     trigger: container,
    //     invalidateOnRefresh: true,
    //     pin: true,
    //     scrub: 0,
    //     end: () => "+=" + container.offsetHeight
    //   }
    // })
    this.loadData();

  },
    methods:{
      isMobile() {
              if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                  return true
              } else {
                  return false
              }
      },
      loadData(){
        const self = this;
        // read in data
        let promises = [
            self.d3.csv(self.publicPath + "data/annotations.csv", this.d3.autoType) // to be repalced with file stored in s3 via pipeline
        ];
        Promise.all(promises).then(self.callback);
      },
      callback(data){
        const self = this;

        const annotation_data = data[0]
        
        this.addOverlay(annotation_data)
      },
      scrollTimeline(e) {
        console.log(e)
        const scrollButton = e.target
        const scrollID = scrollButton.id
        const scrollYear = scrollID.split('-')[1]
        console.log(scrollYear)
        this.$gsap.to(window, {duration: 2, scrollTo:"#scrollStop-"+scrollYear});
      },
      addOverlay(annotation_data) {
        const self = this;

        this.svg = this.d3.select("#svg-chart")

        this.chartWidth = window.innerWidth*0.9
        this.chartHeight = this.chartWidth*9.996

        this.svg
          .attr("viewBox", "0 0 " + this.chartWidth + " " + this.chartHeight)
          .attr("preserveAspectRatio", "xMidYMid meet")
          .attr("width", '100%')

        const allDates = []
        const timelineDates = ['1950-04-01','2020-03-22']
        const scrollToDates = [
          {id: '1950s', date: '1950-04-01'}, 
          {id: '1960s', date: '1960-01-01'},
          {id: '1970s', date: '1970-01-01'},
          {id: '1980s', date: '1980-01-01'},
          {id: '1990s', date: '1990-01-01'},
          {id: '2000s', date: '2000-01-01'},
          {id: '2010s', date: '2010-01-01'}]
        allDates.push(...timelineDates)
        allDates.push(...scrollToDates.map(item => item.date))
        console.log(allDates)
        console.log(Date(timelineDates[0]))
        const yScale = this.d3.scaleTime()
          .domain([new Date(timelineDates[0]), new Date(timelineDates[1])])
          .range([0, this.chartHeight]);
        // const yScale = this.d3.scaleTime()
        //   .domain(this.d3.extent(allDates, function(d) { 
        //     return new Date(d); 
        //   }))
        //   .range([0, this.chartHeight]);
        let testDate = new Date(timelineDates[0])
        console.log(yScale(testDate))

        const yAxis = this.d3.axisLeft(yScale)

        const yAxisDom = this.svg.append("g")
          .call(yAxis)
          .attr("class", "y_axis")
          .attr("transform", "translate(100,0)")

        yAxis.ticks(10)

        const xScale = this.d3.scaleLinear()
          .domain([0,100])
          .range([0, this.chartWidth])

        console

        const scrollToSpot = this.svg.selectAll('scrollToSpot')
          .data(scrollToDates)
          .enter()
          .append('rect')
          .attr("id", d => "scrollStop-" + d.id)
          .attr("class", "scrollToSpot")
          .attr("x", 100)
          .attr("y", d => yScale(new Date(d.date)))
          .attr("width", 10)
          .attr("height", 10)
          .style("fill", "red")

        const annotationText = this.svg.selectAll('annotationText')
          .data(annotation_data)
          .enter()
          .append("text")
          .attr("id", d => "annotation-" + d.id)
          .attr("class", "droughtText")
          .text(d => d.text)

        if (this.mobileView === false) {
          annotationText
            .attr("x", d => xScale(d.x_offset_per))
            .attr("y", d => yScale(new Date(d.date)))
        }
      }
    }
}
</script>
<style scoped lang="scss">
// handwriting font
@import url('https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap');
$writeFont: 'Nanum Pen Script', cursive;

#main-container {
  display: grid;
  padding: 20px 0 20px 0;
  gap: 5px;
  grid-template-columns: 100%;
  grid-template-rows: max-content max-content max-content;
  grid-template-areas:
    "title"
    "buttons"
    "chart";
  justify-content: center;
  margin: auto;
  max-width: 90vw;
}
#title-container {
  grid-area: title;
}
#nav-button-container {
  grid-area: buttons;
  padding: 10px 0px 10px 0px;
}
.button {
  padding: 3px 6px 4px 5px;
  margin-left: 5px;
  @media only screen and (max-width: 600px) {
    padding: 2px 5px 3px 4px;
    margin-left: 0px;
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
#chart-container {
  grid-area: chart;
}
#swarm_vertical {
  width: 100%;
  transform: rotate(180deg)
}
#chart-overlay {
  grid-area: chart;
}
#annotation-container {
  grid-area: chart;
}
.droughtText {
  z-index: 10;
  position: absolute;
  p {
    // color: black;
  }
}

</style>