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
        annotations: droughtAnnotations.timelineEvents,
        // dimensions
        chartWidth: null,
        chartHeight: null,
        // show scroll trigger markers on the page?
        marker_on: false,
        tl: null

      }
  },
  mounted(){      
    this.d3 = Object.assign(d3Base);
    // register plugins for global use
    this.$gsap.registerPlugin(ScrollTrigger, TimelineMax, ScrollToPlugin); 

    // create the scrolling timeline
    this.tl = this.$gsap.timeline(); 

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
    if (this.mobileView) {
      this.addAnimations()
    }
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
        console.log(annotation_data)
        console.log(this.annotations)
        this.svgChart = this.d3.select("#svg-chart")

        this.chartWidth = window.innerWidth*0.9
        this.chartHeight = this.chartWidth*9.996

        this.svgChart
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
        const yScale = this.d3.scaleTime()
          .domain([new Date(timelineDates[0]), new Date(timelineDates[1])])
          .range([0, this.chartHeight]);
        // const yScale = this.d3.scaleTime()
        //   .domain(this.d3.extent(allDates, function(d) { 
        //     return new Date(d); 
        //   }))
        //   .range([0, this.chartHeight]);
        let testDate = new Date(timelineDates[0])

        const yAxisOffset = this.mobileView ? 35: 40;

        const yAxis = this.d3.axisLeft(yScale)
          .ticks(this.d3.timeYear.every(1))
          .tickSize(-this.chartWidth-yAxisOffset)
          .tickSizeOuter(0)


        const yAxisDom = this.svgChart.append("g")
          .call(yAxis)
          .attr("class", "y_axis")
          .attr("transform", "translate(" + yAxisOffset + ",0)")

        yAxisDom.selectAll('text')
          .attr("class", "yAxisText")
        
        yAxisDom.selectAll(".tick line")
          .attr("class", "yAxisTick")

        yAxisDom.select(".domain").remove()

        const xScale = this.d3.scaleLinear()
          .domain([0,100])
          .range([0, this.chartWidth])

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
          .style("fill", "red")

        if (this.mobileView === false) {
          const annotationItems = this.svgChart.selectAll('annotationText')
            .data(annotation_data)
            .enter()
            .append("text")
            .attr("id", d => "annotation-" + d.id)
            .attr("class", "droughtText")
            .attr("x", d => xScale(d.x_offset_per))
            .attr("y", d => yScale(new Date(d.date)))
            .attr("text-anchor", "middle")
            .text(d => d.text)
        } else {
          const annotationItems = this.svgChart.selectAll('annotationText')
            .data(annotation_data)
            .enter()
            .append("circle")
            .attr("id", d => "annotation-" + d.id)
            .attr("class", "droughtCircle")
            .attr("cx", d => xScale(d.x_offset_per))
            .attr("cy", d => yScale(new Date(d.date)))
            .attr("r", 4)
        }
      },
      addAnimations() {
        // find all annotation text
        // const droughtTexts = this.$gsap.utils.toArray("#svg-chart y_axis");
        const chartSVG = document.querySelector("#svg-chart");
        const droughtTexts = this.$gsap.utils.toArray(".droughtText", chartSVG);
        // console.log(droughtTexts)

        droughtTexts.forEach((droughtText) => {
            // get unique ID and class for frame. Scroll frame classes follow the pattern `scrolly scroll-step-${frame.id}`
            // let classList = droughtText.className
            // let scrollClass = classList.split(' ')[1]
            // console.log(scrollClass.split('-')[2])
            let scrollID = droughtText.id
            console.log(scrollID)
          // use class to set trigger
            this.tl.to(`#${scrollID}`, {
              scrollTrigger: {
                markers: this.marker_on,
                trigger: `#${scrollID}`,
                start: "top 70%",
                end: "bottom 70%",
                toggleClass: {targets: `#${scrollID}`, className:"visible"}, // adds class to target when triggered
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
  height: 100px;
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
</style>