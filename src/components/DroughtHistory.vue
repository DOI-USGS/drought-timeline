<template>
  <section id="main-container">
    <section id="grid-container">
      <div id="title-container">
        <h2>Five droughts that changed history</h2>
      </div>
      <div id="intro-container">
        <p>The U.S. has experienced thousands of droughts—periods of drier-than-normal conditions that cause water-related problems for humans and ecosystems (see <a href = "https://labs.waterdata.usgs.gov/visualizations/what-is-drought/index.html#/" target = '_blank'>What is Drought?</a>). But in the last 100 years, five major drought events stand out in their effects on agriculture, wildfires, and streamflow. Scroll through the timeline to see when and where these major drought events occurred across the lower 48 states.</p>
      </div>
      <nav id="nav-button-container">
        <p>
          <span 
            v-for="drought in scrollToDates"
            :key="drought.id"
          ><button
            :id="`button-${drought.id}`"
            class="scrollButton"
            @click="scrollTimeline"
            v-text="drought.name"
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
        :class = "annotation.quote ? 'quote' : ''"
        class="droughtText mobile hidden"
      >
        <p v-html="annotation.text"></p>
      </div>
    </div>
    <div
      v-if="!mobileView"
      id="annotation-container"
    >
      <div
        v-for="narration in narrations" 
        :id="`drought-text-${narration.id}`"
        :key="narration.id"
        :class="`droughtText narration hidden`"
      >
        <p v-html="narration.text"></p>
      </div>
    </div>
    <section id="region-container" class = "page-section">
      <h3>Droughts in every region</h3>
      <p>The five major drought events described above stand out in the history of the conterminous U.S. (the lower 48 states) because of their large effects on agriculture, wildfires, and streamflow. But droughts happen in every region of the U.S., and dry years in some regions are wet years in others. How do the 100-year histories of drought compare across regions?</p>
      <div id = "region-grid-container"></div>
      <div id = "region-description">
        <p>Placeholder for dynamically updating description of region</p>
      </div>
    </section>
    <section id="methods-container" class = "page-section">
      <h3>Methods</h3>
      <p>These are the methods that we used to process the data</p>
    </section>
    <section id="references-container" class = "page-section">
      <h3>References</h3>
      <p>These are the references</p>
    </section>
    <section id="authors-container" class = "page-section">
      <h3>Authors</h3>
      <p>These are the people who contributed to the site</p>
    </section>
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
import droughtAnnotationsDesktop from "@/assets/text/droughtAnnotations_desktop.js";
import droughtAnnotationsMobile from "@/assets/text/droughtAnnotations_mobile.js";
import droughtNarrations_desktop from "@/assets/text/droughtNarrations_desktop.js";
import droughtImages from "@/assets/text/droughtImages.js";
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
        annotations: null,
        narrations: droughtNarrations_desktop.timelineEvents,
        images: droughtImages.timelineEvents,
        scrollToDates:  null,
        // dimensions
        overlayWidth: null,
        overlayHeight: null
      }
  },
  mounted(){      
    this.d3 = Object.assign(d3Base);
    // register plugins for global use
    this.$gsap.registerPlugin(ScrollTrigger, TimelineMax, ScrollToPlugin); 

    // Define scrollTo dates
    this.scrollToDates = [
      {id: '1930', name: 'Dust Bowl', start: '1930-02-01', end: '1941-08-31'}, 
      {id: '1952', name: '1950s Drought', start: '1952-11-01', end: '1957-08-31'}, 
      {id: '1962', name: '1960s Drought', start: '1962-12-01', end: '1968-10-31'}, 
      {id: '1987', name: '1980s Drought', start: '1987-05-01', end: '1992-10-31'},
      {id: '1999', name: 'Turn-of-the-Century Drought', start: '1999-09-01', end: '2015-09-30'}]

    // Define annotations source for desktop and mobile
    this.annotations = this.mobileView ? droughtAnnotationsMobile.timelineEvents: droughtAnnotationsDesktop.timelineEvents;

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

        // determine which year we are in on the timeline
        // currently, scroll trigger start and end set up so that there is always 1+ year 'inView'
        const currentYearElement = document.querySelector('.inView'); // pulls first element w/ class
        let currentYear = currentYearElement.id.split('-')[1];

        // determine which year should be scrolled to, based on selected drought
        const scrollButton = e.target;
        const scrollID = scrollButton.id;
        const scrollDroughtYear = scrollID.split('-')[1];

        // determine scroll length, based on # of years scrolled
        const scrollDistance = Math.abs(scrollDroughtYear - currentYear);
        const scrollSpeed = 9;
        const scrollLength =  scrollDistance/scrollSpeed;
        
        // scroll to position of specified drought
        this.$gsap.to(window, {duration: scrollLength, scrollTo: {y: "#scrollStop-" + scrollDroughtYear, offsetY: 100}});
      },
      addOverlay() {
        const self = this;

        const annotation_data = this.annotations
        const narration_data = this.narrations
        const image_data = this.images

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
        const timelineDates = ['1921-10-01','2020-04-01']
        const yScale = this.d3.scaleTime()
          .domain([new Date(timelineDates[0]), new Date(timelineDates[1])])
          .range([0, this.overlayHeight]);

        // set y-axis offset
        const yAxisOffset = this.mobileView ? 40: 45;

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
          .attr("y", d => yScale(new Date(d.start)))
          .attr("width", this.overlayWidth - yAxisOffset)
          .attr("height", (d) => {
            return yScale(new Date(d.end)) - yScale(new Date(d.start))
          })
          .attr("rx", 4)
          .attr("fill", "#F1F1F1") // fill in light grey so drought events highlighted
          .attr("opacity", 1)
        
        // Add y axis
        const yAxis = this.d3.axisLeft(yScale)
          .ticks(this.d3.timeYear.every(1))
          .tickSize(-this.overlayWidth-yAxisOffset) // ticks spanning width of chart
          .tickSizeOuter(0)

        const yAxisDom = this.svgChartDynamic.append("g")
          .call(yAxis)
          .attr("class", "y_axis")
          .attr("transform", "translate(" + yAxisOffset + ",0)")

        // set up classes for styling
        const yearFormat = this.d3.timeFormat("%Y")
        yAxisDom.selectAll('text')
          .attr("class", "yAxisText")
          .attr("id", (d) => "tick-" + yearFormat(d));
        
        yAxisDom.selectAll(".tick line")
          .attr("class", "yAxisTick")

        // remove y axis line
        yAxisDom.select(".domain").remove()

        // Set up annotations
        if (this.mobileView === false) {
          // On desktop, place annotations as text
          const annotationItems = this.svgChartDynamic.selectAll('annotationText')
            .data(annotation_data.sort((a,b) => this.d3.ascending(a.date, b.date)))
            .enter()
            .append("svg:a").attr("xlink:href", function(d){ return d.url }).attr("target", "_blank")
            .append("text")
            .attr("id", d => "annotation-text-" + d.id)
            .attr("class", d => d.quote ? "droughtText desktop quote hidden" : "droughtText desktop hidden")
            .attr("x", d => xScale(d.desktop_x_offset_per))
            .attr("y", d => yScale(new Date(d.date)))
            .attr("text-anchor", d => d.desktop_text_anchor)
            .attr("data-width", d => d.desktop_text_width)
            .text(d => d.text)
            .call(self.wrap);
          // On desktop, set up rectangles to trigger narrations in box at bottom
          const narrationRects = this.svgChartDynamic.selectAll('narrationRect')
            .data(narration_data.sort((a,b) => this.d3.ascending(a.start_date, b.start_date)))
            .enter()
            .append("rect")
            .attr("id", d => "narration-rect-" + d.id)
            .attr("class", "droughtRect")
            .attr("x", yAxisOffset)
            .attr("y", d => yScale(new Date(d.start_date)))
            .attr("width", this.overlayWidth - yAxisOffset)
            .attr("height", (d,i) => {
              const y_diff = yScale(new Date(d.end_date)) - yScale(new Date(d.start_date))
              return y_diff
            })
            .style('opacity', 0)
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

        // Set up images
        const annotationImages = this.svgChartDynamic.selectAll('annotationImages')
          .data(image_data.sort((a,b) => this.d3.ascending(a.date, b.date)))
          .enter()
          .append("svg:a").attr("xlink:href", function(d){ return d.url }).attr("target", "_blank")
          .append("svg:image")
          .attr("id", d => "annotation-image-" + d.id)
          .attr("class", "droughtImage hidden")
          .attr("x", d => this.mobileView ? xScale(d.mobile_x_offset_per) : xScale(d.desktop_x_offset_per))
          .attr("y", d => yScale(new Date(d.date)))
          .attr("width", d => this.mobileView ? xScale(d.mobile_width_per) : xScale(d.desktop_width_per))
          .attr("xlink:href", d => d.url)
          .attr("alt", d => d.alt)

      },
      addAnimations() {
        // Set up timeline
        const tl = this.$gsap.timeline(); 

        // Select dynamically added chart overlay svg
        const dynamicSVG = document.querySelector("#svg-dynamic");

        // Add in view animations to tick marks, so that we know which years are in the current view
        const tickMarkTriggers = this.$gsap.utils.toArray(".yAxisText")
        tickMarkTriggers.forEach((tickMarkTrigger) => {
          // get unique ID for scroll step.
          let scrollIDFull = tickMarkTrigger.id

          // When each year is in view on the timeline, add 'inView' class to element
          // NOTE: no visual change - simply for use in scrollTimeline()
          tl.to(`#${scrollIDFull}`, {
            scrollTrigger: {
              markers: false,
              trigger: `#${scrollIDFull}`,
              start: "top 90%",
              end: 'bottom 10%',
              toggleClass: {targets: `#${scrollIDFull}`, className:"inView"}, // adds class to target when triggered
              toggleActions: "restart reverse none reverse" 
            },
          })
        })

        // Add scrollTo animations
        const scrollToTriggers = this.$gsap.utils.toArray(".scrollToSpot")
        scrollToTriggers.forEach((scrollToTrigger) => {

          // get unique ID for scroll step.
          let scrollIDFull = scrollToTrigger.id
          let scrollID = scrollIDFull.split('-')[1]

          // Highlight the menu item for each drought
          // when in that drought period
          tl.to(`#${scrollIDFull}`, {
            scrollTrigger: {
              markers: false,
              trigger: `#${scrollIDFull}`,
              start: "top 25%",
              end: 'bottom 25%',
              toggleClass: {targets: `#button-${scrollID}`, className:"currentButton"}, // adds class to target when triggered
              toggleActions: "restart reverse none reverse" 
            },
          })

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
                  start: `top 80%`,
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
                  start: `top 80%`,
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
                start: "top 75%",
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

          // find all narration text triggers (rectangles)
          const droughtNarrationTriggers = this.$gsap.utils.toArray(".droughtRect", dynamicSVG)

          // For each trigger,
          droughtNarrationTriggers.forEach((droughtNarrationTrigger) => {

            // get unique ID for text step.
            let rectIDFull = droughtNarrationTrigger.id
            let rectlID = rectIDFull.split('-')[2]
            
            // Make the narrative text for the step visible
            tl.to(`#${rectIDFull}`, {
              scrollTrigger: {
                markers: false,
                trigger: `#${rectIDFull}`,
                start: `top 25%`,
                end: 'bottom 25%',
                toggleClass: {targets: `#drought-text-${rectlID}`, className:"visible"}, // adds class to target when triggered
                toggleActions: "restart reverse none reverse" 
              },
            })
          })
        }

        // Add image animations
        const droughtImages = this.$gsap.utils.toArray(".droughtImage", dynamicSVG)

        // For each trigger,
        droughtImages.forEach((droughtImage) => {

          // get unique ID for text step.
          let imageIDFull = droughtImage.id
          let imagelID = imageIDFull.split('-')[2]
          
          // Make the image for the step visible
          tl.to(`#${imageIDFull}`, {
            scrollTrigger: {
              markers: false,
              trigger: `#${imageIDFull}`,
              start: `top 25%`,
              end: 'bottom 25%',
              toggleClass: {targets: `#annotation-image-${imagelID}`, className:"visible"}, // adds class to target when triggered
              toggleActions: "restart reverse none reverse" 
            },
          })
        })

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
    "intro"
    "buttons"
    "chart";
  justify-content: center;
  margin: auto;
  max-width: 90vw;
}
#title-container {
  grid-area: title;
}
#intro-container {
  grid-area: intro;
  padding-left: 5px;
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
  top: 55px;
  height: 150px;
  filter: url(#shadow2);
  @media only screen and (max-width: 600px) {
    height: 75px;
    top: 75px;
  }
}
#chart-container {
  grid-area: chart;
}
#swarm_vertical {
  width: 100%;
  transform: rotate(180deg);
  pointer-events: none;
}
#chart-overlay-dynamic {
  grid-area: chart;
}
#chart-overlay-static {
  grid-area: chart;
  pointer-events: none;
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
.droughtText.mobile {
  margin: 0 5vw 0 5vw;
  position: absolute;
}
.droughtText.narration {
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
.page-section {
  margin: auto;
  max-width: 90vw;
}
#region-grid-container {
  height: 500px;
  display: grid
}
#region-description {
  height: 100px;
}
#methods-container {
  height: 300px;
}
#references-container {
  height: 300px;
}
#authors-container {
  height: 300px;
}
</style>
<style lang="scss">
.droughtText {
  z-index: 10;
  font-weight: 300;
  font-size: 1em;
  -webkit-user-select: none; /* Safari */
  -ms-user-select: none; /* IE 10 and IE 11 */
  user-select: none; /* Standard syntax */
}
.droughtText.mobile {
  z-index: 10;
  font-weight: 500;
  font-size: 1em;
}
.droughtText.quote {
  font-style: italic;
}
.droughtText.desktop.quote {
  text-shadow: 2px 4px 4px rgba(179,179,179,0.6);
}
.droughtText.desktop.quote:hover {
  font-style: italic;
  font-weight: 500;
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