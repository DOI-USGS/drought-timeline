<template>
<section id="main-container">
  <section id="grid-container">
    <div id="title-container">
      <h2>A history of drought in the western U.S.</h2>
    </div>
    <nav id="nav-button-container">
      <p>
        <span><button id='button-1950s' class="button firstButton" @click="scrollTimeline">1950s</button></span>
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
    <div id="inset-container">
      <img id="inset-map" src="@/assets/images/western_states_inset.png" alt=""/>
    </div>
    <div id="chart-overlay">
      <svg id="svg-chart"/>
    </div>
  </section>
  <div id="annotation-container" v-if="mobileView">
    <div
        v-for="annotation in annotations" 
        :key="annotation.id"
        :class="`droughtText mobile hidden`"
        :id="`drought-text-${annotation.id}`"
      >
        <p>{{ annotation.text }}</p>
      </div>
  </div>
  <svg id="filter-svg">
    <filter
      id="shadow2"
      style="width: 0px; height:0px"
    >
      <feDropShadow
        dx="0"
        dy="0"
        stdDeviation="5"
        flood-color="#c9c9c9"
      />
    </filter>
    </svg>
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
        annotations: droughtAnnotations.timelineEvents,
        // dimensions
        chartWidth: null,
        chartHeight: null,
        // show scroll trigger markers on the page?
        marker_on: false
      }
  },
  mounted(){      
    this.d3 = Object.assign(d3Base);
    // register plugins for global use
    this.$gsap.registerPlugin(ScrollTrigger, TimelineMax, ScrollToPlugin); 

    // let container = document.getElementById("chart-container");
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
    this.addOverlay(this.annotations)

    this.addAnimations()
  },
    methods:{
      isMobile() {
              if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                  return true
              } else {
                  return false
              }
      },
      scrollTimeline(e) {
        const scrollButton = e.target
        const scrollID = scrollButton.id
        const scrollYear = scrollID.split('-')[1]
        this.$gsap.to(window, {duration: 2, scrollTo:"#scrollStop-"+scrollYear});
      },
      addOverlay(annotation_data) {
        const self = this;

        // select svg
        this.svgChart = this.d3.select("#svg-chart")

        // set dimensions for overlay svg
        this.chartWidth = window.innerWidth*0.9 //MUST MATCH max-width of grid, which controls chart image width
        this.chartHeight = this.chartWidth*9.996 //Based on image aspect ratio
        this.svgChart
          .attr("viewBox", "0 0 " + this.chartWidth + " " + this.chartHeight)
          .attr("preserveAspectRatio", "xMidYMid meet")
          .attr("width", '100%')

        // Define relevant dates
        const timelineDates = ['1950-04-01','2020-03-22']
        const scrollToDates = [
          {id: '1950s', date: '1950-04-01'}, 
          {id: '1960s', date: '1960-01-01'},
          {id: '1970s', date: '1970-01-01'},
          {id: '1980s', date: '1980-01-01'},
          {id: '1990s', date: '1990-01-01'},
          {id: '2000s', date: '2000-01-01'},
          {id: '2010s', date: '2010-01-01'}]
        const yScale = this.d3.scaleTime()
          .domain([new Date(timelineDates[0]), new Date(timelineDates[1])])
          .range([0, this.chartHeight]);

        // set up y axis
        const yAxisOffset = this.mobileView ? 40: 40;

        const yAxis = this.d3.axisLeft(yScale)
          .ticks(this.d3.timeYear.every(1))
          .tickSize(-this.chartWidth-yAxisOffset) // ticks spanning width of chart
          .tickSizeOuter(0)

        const yAxisDom = this.svgChart.append("g")
          .call(yAxis)
          .attr("class", "y_axis")
          .attr("transform", "translate(" + yAxisOffset + ",0)")

        // set up classes for styling
        yAxisDom.selectAll('text')
          .attr("class", "yAxisText")
        
        yAxisDom.selectAll(".tick line")
          .attr("class", "yAxisTick")

        // remove y axis line
        yAxisDom.select(".domain").remove()

        // Set up linear scale for chart width
        const xScale = this.d3.scaleLinear()
          .domain([0,100])
          .range([0, this.chartWidth])

        // Add scroll to elements (only used for scroll navigation)
        const scrollToSpot = this.svgChart.selectAll('scrollToSpot')
          .data(scrollToDates)
          .enter()
          .append('rect')
          .attr("id", d => "scrollStop-" + d.id)
          .attr("class", "scrollToSpot")
          .attr("x", 0)
          .attr("y", d => yScale(new Date(d.date)))
          .attr("width", 10)
          .attr("height", 10)
          .attr("opacity", 0) // make fully transparent

        // Set up annotations
        if (this.mobileView === false) {
          // On desktop, place annotations as text
          const annotationItems = this.svgChart.selectAll('annotationText')
            .data(annotation_data)
            .enter()
            .append("text")
            .attr("id", d => "annotation-text-" + d.id)
            .attr("class", d => "droughtText hidden")
            .attr("x", d => xScale(d.x_offset_per))
            .attr("y", d => yScale(new Date(d.date)))
            .attr("text-anchor", "middle")
            .text(d => d.text)
        } else {
          // On mobile, place circles at annotation locations
          const annotationItems = this.svgChart.selectAll('annotationText')
            .data(annotation_data)
            .enter()
            .append("circle")
            .attr("id", d => "annotation-circle-" + d.id)
            .attr("class", "droughtCircle")
            .attr("cx", d => xScale(d.x_offset_per))
            .attr("cy", d => yScale(new Date(d.date)))
            .attr("r", 4)
        }
      },
      addAnimations() {
        const tl = this.$gsap.timeline(); 
        const chartSVG = document.querySelector("#svg-chart");
        if (this.mobileView) {

          // find all annotation text triggers
          const droughtTextTriggers = this.$gsap.utils.toArray(".droughtCircle", chartSVG)
          // const droughtTexts = this.$gsap.utils.toArray(".droughtText");
          console.log(droughtTextTriggers)

          droughtTextTriggers.forEach((droughtTextTrigger) => {
            // get unique ID and class for frame. Scroll frame classes follow the pattern `scrolly scroll-step-${frame.id}`
            let scrollIDFull = droughtTextTrigger.id
            // console.log(scrollClass.split('-')[2])
            let scrollID = scrollIDFull.split('-')[2]
            console.log(scrollIDFull)
            console.log(scrollID)
            // use class to set trigger
            tl.to(`#${scrollIDFull}`, {
              scrollTrigger: {
                markers: true,
                trigger: `#${scrollIDFull}`,
                start: "top 80%",
                end: "none",
                toggleClass: {targets: `#drought-text-${scrollID}`, className:"visible"}, // adds class to target when triggered
                toggleActions: "restart reverse none reverse" 
                /*
                onEnter - scrolling down, start meets scroller-start
                onLeave - scrolling down, end meets scroller-end
                onEnterBack - scrolling up, end meets scroller-end
                onLeaveBack - scrolling up, start meets scroller-start
                */
              },
            }, ">") 
          })
        } else {
          const droughtTexts = this.$gsap.utils.toArray(".droughtText", chartSVG)
          console.log(droughtTexts)
          
          droughtTexts.forEach((droughtText) => {
            // get unique ID and class for frame. Scroll frame classes follow the pattern `scrolly scroll-step-${frame.id}`
            let scrollIDFull = droughtText.id
            // console.log(scrollClass.split('-')[2])
            let scrollID = scrollIDFull.split('-')[2]
            console.log(scrollIDFull)
            console.log(scrollID)
            // use class to set trigger
            tl.to(`#${scrollIDFull}`, {
              scrollTrigger: {
                markers: false,
                trigger: `#${scrollIDFull}`,
                start: "top 95%",
                end: "bottom 35%",
                toggleClass: {targets: `#${scrollIDFull}`, className:"visible"}, // adds class to target when triggered
                toggleActions: "restart reverse none reverse" 
                /*
                onEnter - scrolling down, start meets scroller-start
                onLeave - scrolling down, end meets scroller-end
                onEnterBack - scrolling up, end meets scroller-end
                onLeaveBack - scrolling up, start meets scroller-start
                */
              },
            }) 
          })
        }
      }
    }
}
</script>
<style scoped lang="scss">
// handwriting font
@import url('https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap');
$writeFont: 'Nanum Pen Script', cursive;

#grid-container {
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
  position: sticky;
  top: 0px;
  padding: 10px 0px 10px 0px;
  z-index: 20;
  background-color: white;
}
.button {
  padding: 3px 6px 4px 5px;
  margin-left: 5px;
  @media only screen and (max-width: 600px) {
    padding: 2px 5px 3px 4px;
    margin-left: 0px;
  }
}
.button.firstButton {
  margin-left: 0px;
}
.button:hover {
  background-color: black;
  color: white;
  border-radius: 3px;
}
#inset-container {
  grid-area: chart;
  justify-self: end;
}
#inset-map {
  position: sticky;
  top: 50px;
  height: 150px;
  filter: url(#shadow2);
  @media only screen and (max-width: 600px) {
    height: 75px;
  }
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
  height: 20vh;
  width: 100vw;
  position: fixed;
  bottom: 0;
  background-color: white;
  opacity: 0.8;
  box-shadow: 0px -5px 5px #B9B9B9;
}
.droughtText {
  z-index: 10;
  position: absolute;
}
.hidden{
  visibility: hidden;
  opacity: 0;
  transition: visibility 0s 0.5s, opacity 0.5s linear;
}
.visible{
  visibility: visible;
  opacity: 1;
  transition: opacity 0.5s linear;
}
</style>
<style lang="scss">
.yAxisText {
  font-size: 2em;
  @media only screen and (max-width: 600px) {
    font-size: 1.6em;
  }
}
.yAxisTick {
  stroke: #949494;
  stroke-width: 0.5;
}
.droughtCircle {
  stroke: #949494;
  stroke-width: 1;
  fill: #ffffff
}
.hidden{
  visibility: hidden;
  opacity: 0;
  transition: visibility 0s 0.5s, opacity 0.5s linear;
}
.visible{
  visibility: visible;
  opacity: 1;
  transition: opacity 0.5s linear;
}
</style>