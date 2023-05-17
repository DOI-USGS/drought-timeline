<template>
  <section id="main-container">
    <section id="grid-container">
      <div id="title-container">
        <h2>100 years of severe drought in the contiguous U.S.</h2>
      </div>
      <nav id="nav-button-container">
        <p>
          <span 
            v-for="decade in decadeIDs"
            :key="decade"
          ><button
            :id="`button-${decade}`"
            class="scrollButton"
            @click="scrollTimeline"
            v-text="decade"
          /></span>
        </p>
      </nav>
      <div id="chart-container">
        <img
          id="swarm_vertical"
          src="@/assets/images/duration-chart/swarm_jd7d_2pct_compressed_vertical.png"
          alt=""
        >
      </div>
      <div id="inset-container">
        <img
          id="inset-map"
          src="@/assets/images/states_stations_inset.png"
          alt=""
        >
      </div>
      <div id="chart-overlay-dynamic">
        <svg id="svg-dynamic" />
      </div>
      <div id="chart-overlay-static">
        <annotationDrawings />
      </div>
    </section>
    <div
      v-if="mobileView"
      id="annotation-container"
    >
      <div
        v-for="annotation in annotations" 
        :id="`drought-text-${annotation.id}`"
        :key="annotation.id"
        :class="`droughtText mobile hidden`"
      >
        <p>{{ annotation.text }}</p>
      </div>
    </div>
    <div id="empty-div" />
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
import annotationDrawings from "@/assets/svgs/annotation_drawings-01.svg";
export default {
  name: "DroughtHistory",
    components: {
      annotationDrawings
    },
    props: {
    },
    data() {
      return {
        d3: null,
        publicPath: process.env.BASE_URL, // allows the application to find the files when on different deployment roots
        mobileView: isMobile, // test for mobile
        annotations: droughtAnnotations.timelineEvents,
        scrollToDates:  null,
        decadeIDs: null,
        // dimensions
        overlayWidth: null,
        overlayHeight: null,
        // show scroll trigger markers on the page?
        marker_on: false
      }
  },
  mounted(){      
    this.d3 = Object.assign(d3Base);
    // register plugins for global use
    this.$gsap.registerPlugin(ScrollTrigger, TimelineMax, ScrollToPlugin); 

    // Define scrollTo dates
    this.scrollToDates = [
      {id: '1920s', date: '1921-10-01'}, 
      {id: '1930s', date: '1930-01-01'}, 
      {id: '1940s', date: '1940-01-01'}, 
      {id: '1950s', date: '1950-01-01'}, 
      {id: '1960s', date: '1960-01-01'},
      {id: '1970s', date: '1970-01-01'},
      {id: '1980s', date: '1980-01-01'},
      {id: '1990s', date: '1990-01-01'},
      {id: '2000s', date: '2000-01-01'},
      {id: '2010s', date: '2010-01-01'}]
    // Get all possible button ids
    this.decadeIDs = this.scrollToDates.map(scrollDate => scrollDate.id);

    // sort annotations
    this.annotations.sort((a,b) => this.d3.ascending(a.date, b.date))

    this.addOverlay()

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

        // determine which decade is already shown
        const currentButton = document.querySelector('.currentButton')
        let currentDecade = currentButton == null ? this.decadeIDs[0] : currentButton.id.split('-')[1]; // currently goes to null when user scrolls back to top of page
        const currentIndex = this.decadeIDs.indexOf(currentDecade, 0)

        // determine which decade should be scrolled to
        const scrollButton = e.target
        const scrollID = scrollButton.id
        const scrollYear = scrollID.split('-')[1]

        // determine scroll length, based on # of decades scrolled
        const nextIndex = this.decadeIDs.indexOf(scrollYear, 0)
        const scrollLength = Math.abs(nextIndex - currentIndex) + 1 * 0.4

        // scroll to position of specified decade
        this.$gsap.to(window, {duration: scrollLength, scrollTo:"#scrollStop-"+scrollYear});
      },
      addOverlay() {
        const self = this;

        const annotation_data = this.annotations

        // set viewbox for svg with static overlay drawings
        const svgChartStatic = this.d3.select("#svg-static")
          .attr("viewBox", "0 0 " + 720 + " " + 7200)
          .attr("preserveAspectRatio", "xMidYMid meet")
          .attr("width", '100%')
          .attr("height", '100%')

        // hide all elements of static svg to start
        svgChartStatic.selectAll('g')
          .classed('hidden', true)

        // select svg that will hold dynamically added overlay content
        this.svgChartDynamic = this.d3.select("#svg-dynamic")

        // set dimensions for overlay svg
        this.overlayWidth = window.innerWidth*0.9 //MUST MATCH max-width of grid, which controls chart image width
        this.overlayHeight = this.overlayWidth*10 //Based on image aspect ratio
        this.svgChartDynamic
          .attr("viewBox", "0 0 " + this.overlayWidth + " " + this.overlayHeight)
          .attr("preserveAspectRatio", "xMidYMid meet")
          .attr("width", '100%')

        // Define y scale based on timeline start and end dates
        const timelineDates = ['1921-10-01','2019-12-01']
        const yScale = this.d3.scaleTime()
          .domain([new Date(timelineDates[0]), new Date(timelineDates[1])])
          .range([0, this.overlayHeight]);

        // set up y axis
        const yAxisOffset = this.mobileView ? 40: 45;

        const yAxis = this.d3.axisLeft(yScale)
          .ticks(this.d3.timeYear.every(1))
          .tickSize(-this.overlayWidth-yAxisOffset) // ticks spanning width of chart
          .tickSizeOuter(0)

        const yAxisDom = this.svgChartDynamic.append("g")
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
          .range([0, this.overlayWidth])

        // Add scroll to elements (only used for scroll navigation)
        const scrollToSpot = this.svgChartDynamic.selectAll('scrollToSpot')
          .data(this.scrollToDates)
          .enter()
          .append('rect')
          .attr("id", d => "scrollStop-" + d.id)
          .attr("class", "scrollToSpot")
          .attr("x", yAxisOffset)
          .attr("y", d => yScale(new Date(d.date)))
          .attr("width", this.overlayWidth - yAxisOffset)
          .attr("height", (d,i) => {
            return i===this.scrollToDates.length-1 ? 
              yScale(new Date(timelineDates[1])) - yScale(new Date(d.date)) : 
              yScale(new Date(this.scrollToDates[i+1].date)) - yScale(new Date(d.date))
          })
          .attr("opacity", 0) // make fully transparent
        // Set up annotations
        if (this.mobileView === false) {
          // On desktop, place annotations as text
          const annotationItems = this.svgChartDynamic.selectAll('annotationText')
            .data(annotation_data)
            .enter()
            .append("text")
            .attr("id", d => "annotation-text-" + d.id)
            .attr("class", d => "droughtText desktop hidden")
            .attr("x", d => xScale(d.desktop_x_offset_per))
            .attr("y", d => yScale(new Date(d.date)))
            .attr("text-anchor", d => d.desktop_text_anchor)
            .attr("data-width", d => d.desktop_text_width)
            .text(d => d.text)
            .call(self.wrap);
        } else {
          // On mobile, set up rectangles to trigger annotations
          const annotationRects = this.svgChartDynamic.selectAll('annotationRect')
            .data(annotation_data.sort((a,b) => this.d3.ascending(a.date, b.date)))
            .enter()
            .append("rect")
            .attr("id", d => "annotation-rect-" + d.id)
            .attr("class", "droughtRect")
            .attr("x", yAxisOffset)
            .attr("y", d => yScale(new Date(d.date)))
            .attr("width", this.overlayWidth - yAxisOffset)
            .attr("height", (d,i) => {
              const y_diff = i===annotation_data.length-1 ? 
                yScale(new Date(timelineDates[1])) - yScale(new Date(d.date)) : 
                yScale(new Date(annotation_data[i+1].date)) - yScale(new Date(d.date))
              return y_diff > 300 ? 300 : y_diff
            })
            .style('opacity', 0)
          // On mobile, place circles at annotation locations
          const annotationCircles = this.svgChartDynamic.selectAll('annotationCircle')
            .data(annotation_data)
            .enter()
            .append("circle")
            .attr("id", d => "annotation-circle-" + d.id)
            .attr("class", "droughtCircle")
            .attr("cx", d => xScale(d.mobile_x_offset_per))
            .attr("cy", d => yScale(new Date(d.date)))
            .attr("r", 4)
        }
      },
      addAnimations() {
        // Set up timeline
        const tl = this.$gsap.timeline(); 

        // Select dynamically added chart overlay svg
        const dynamicSVG = document.querySelector("#svg-dynamic");

        // Add scrollTo animations
        const scrollToTriggers = this.$gsap.utils.toArray(".scrollToSpot")
        scrollToTriggers.forEach((scrollToTrigger) => {

          // get unique ID for scroll step.
          let scrollIDFull = scrollToTrigger.id
          let scrollID = scrollIDFull.split('-')[1]

          // figure out index of ID
          const scrollIndex = this.decadeIDs.indexOf(scrollID, 0)

          // Highlight the menu item for each decade
          // Make sure first decade button highlighted on page load
          if (scrollIndex === 0) {
            tl.to(`#${scrollIDFull}`, {
              scrollTrigger: {
                markers: false,
                trigger: `#${scrollIDFull}`,
                start: "top center",
                end: 'bottom 15%',
                toggleClass: {targets: `#button-${scrollID}`, className:"currentButton"}, // adds class to target when triggered
                toggleActions: "restart reverse none reverse" 
                /*
                onEnter - scrolling down, start meets scroller-start
                onLeave - scrolling down, end meets scroller-end
                onEnterBack - scrolling up, end meets scroller-end
                onLeaveBack - scrolling up, start meets scroller-start
                */
              },
            })
          } else {
            tl.to(`#${scrollIDFull}`, {
              scrollTrigger: {
                markers: false,
                trigger: `#${scrollIDFull}`,
                start: "top 15%",
                end: 'bottom 15%',
                toggleClass: {targets: `#button-${scrollID}`, className:"currentButton"}, // adds class to target when triggered
                toggleActions: "restart reverse none reverse" 
              },
            })
          }

        })

        // Add text animations
        if (this.mobileView) {
          // On mobile...

          // find all annotation text triggers (rectangles)
          const droughtTextTriggers = this.$gsap.utils.toArray(".droughtRect", dynamicSVG)

          // For each trigger,
          droughtTextTriggers.forEach((droughtTextTrigger) => {

            // get unique ID for text step.
            let rectIDFull = droughtTextTrigger.id
            let rectlID = rectIDFull.split('-')[2]
            
            // Make the text for the step visible, and the drawing, if there is one
            // Make sure first text visible and first circle selected on page load
            if (rectlID === this.annotations[0].id) {
              tl.to(`#${rectIDFull}`, {
                scrollTrigger: {
                  markers: false,
                  trigger: `#${rectIDFull}`,
                  start: `top center`,
                  end: 'bottom 200',
                  toggleClass: {targets: [`#drought-text-${rectlID}`, `#annotation-drawing-${rectlID}`], className:"visible"}, // adds class to target when triggered
                  toggleActions: "restart reverse none reverse" 
                },
              })
              // Highlight the circle for each step
              tl.to(`#${rectIDFull}`, {
                scrollTrigger: {
                  markers: false,
                  trigger: `#${rectIDFull}`,
                  start: `top center`,
                  end: 'bottom 200',
                  toggleClass: {targets: `#annotation-circle-${rectlID}`, className:"currentCircle"}, // adds class to target when triggered
                  toggleActions: "restart reverse none reverse" 
                },
              })
            } else {
              tl.to(`#${rectIDFull}`, {
                scrollTrigger: {
                  markers: false,
                  trigger: `#${rectIDFull}`,
                  start: `top 200`,
                  end: 'bottom 200',
                  toggleClass: {targets: [`#drought-text-${rectlID}`, `#annotation-drawing-${rectlID}`], className:"visible"}, // adds class to target when triggered
                  toggleActions: "restart reverse none reverse" 
                },
              })
              // Highlight the circle for each step
              tl.to(`#${rectIDFull}`, {
                scrollTrigger: {
                  markers: false,
                  trigger: `#${rectIDFull}`,
                  start: `top 200`,
                  end: 'bottom 200',
                  toggleClass: {targets: `#annotation-circle-${rectlID}`, className:"currentCircle"}, // adds class to target when triggered
                  toggleActions: "restart reverse none reverse" 
                },
              })
            }

          })
        } else {
          // On desktop...

          const droughtTexts = this.$gsap.utils.toArray(".droughtText", dynamicSVG)

          droughtTexts.forEach((droughtText) => {
           // get unique ID for text annotation
            let scrollIDFull = droughtText.id
            let scrollID = scrollIDFull.split('-')[2]

            // use id to set trigger
            tl.to(`#${scrollIDFull}`, {
              scrollTrigger: {
                markers: false,
                trigger: `#${scrollIDFull}`,
                start: "top 95%",
                end: "bottom 25%",
                toggleClass: {targets: [`#${scrollIDFull}`,`#annotation-drawing-${scrollID}`], className:"visible"}, // adds class to target when triggered
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
      },
      // function to wrap text added with d3 modified from
      // https://stackoverflow.com/questions/24784302/wrapping-text-in-d3
      // which is adapted from https://bl.ocks.org/mbostock/7555321
      wrap(text) {
        const self = this;
        text.each(function () {
            var text = self.d3.select(this),
                words = text.text().split(/\s+/).reverse(),
                word,
                line = [],
                lineNumber = 0,
                lineHeight = 1.1, // ems
                x = text.attr("x"),
                y = text.attr("y"),
                width = text.attr("data-width"),
                dy = 0, //parseFloat(text.attr("dy")),
                tspan = text.text(null)
                            .append("tspan")
                            .attr("x", x)
                            .attr("y", y)
                            .attr("dy", dy + "em");
            while (word = words.pop()) {
                line.push(word);
                tspan.text(line.join(" "));
                if (tspan.node().getComputedTextLength() > width) {
                    line.pop();
                    tspan.text(line.join(" "));
                    line = [word];
                    tspan = text.append("tspan")
                                .attr("x", x)
                                .attr("y", y)
                                .attr("dy", ++lineNumber * lineHeight + dy + "em")
                                .text(word);
                }
            }
        });
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
.scrollButton {
  padding: 3px 6px 4px 5px;
  margin-left: 5px;
  border: 0.5px solid white;
  border-radius: 3px;
  @media only screen and (max-width: 600px) {
    padding: 2px 4px 2px 3px;
    margin-left: 0px;
  }
}
#button-1950s {
  margin-left: 0px;
}
.scrollButton:hover {
  border-color: black;
  @media only screen  and (max-width: 800px){
    border-color: white
  }
}
.scrollButton:focus {
  border-color: white;
}
.scrollButton:active {
  border-color: black;
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
#chart-overlay-dynamic {
  grid-area: chart;
}
#chart-overlay-static {
  grid-area: chart;
}
// Class for paths in AI-generated annotation_drawings-01.svg
.cls-1 {
  fill: none;
  stroke: black;
  stroke-width: 1;
}
#annotation-container {
  height: 20vh;
  width: 100vw;
  padding: 20px 0 10px 0;
  position: fixed;
  bottom: 0;
  background-color: white;
  opacity: 0.8;
  box-shadow: 0px -5px 5px #B9B9B9;
}
.droughtText {
  z-index: 10;
}
.droughtText.mobile {
  margin: 0 5vw 0 5vw;
  position: absolute;
}
.hidden{
  visibility: hidden;
  opacity: 0;
  transition: visibility 0s 0.3s, opacity 0.3s linear;
}
.visible{
  visibility: visible;
  opacity: 1;
  transition: opacity 0.3s linear;
}
.currentButton {
  background-color: black;
  border-color: black;
  color: white;
}
.currentButton:hover {
  background-color: black;
  color: white;
}
#filter-svg {
  width: 0;
  height: 0;
}
#empty-div {
  height: 300px;
}
</style>
<style lang="scss">
.droughtText {
  z-index: 10;
  font-weight: 300;
  font-size: 1em;
}
.droughtText.mobile {
  z-index: 10;
  font-weight: 500;
  font-size: 1em;
}
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
  transition: visibility 0s 0.3s, opacity 0.3s linear;
}
.visible{
  visibility: visible;
  opacity: 1;
  transition: opacity 0.3s linear;
}
.currentCircle {
  stroke: #000000;
  fill: #000000;
  transform-box:fill-box; 
  transform-origin: left;  
  transform:scale(1.1,1.1);
}
</style>