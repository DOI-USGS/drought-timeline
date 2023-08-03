export default {
    timelineEvents: [
      {
        id: 'intro_1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by start_date
        start_date: '1922-04-01', // Date marking start of annotation. Determines y trigger start position on deskop and order
        end_date: '1926-08-31', // Date marking end of annotation. Determines y trigger end position on deskop
        text: 'Each bar represents one of the 2000 most severe streamflow drought events measured at a USGS  streamgage. The taller the bar, the longer the drought. Where the chart is wider, many streamgages were experiencing drought simultaneously.', // Narrative text
      },
      {
        id: 'dustbowl_1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by start_date
        start_date: '1930-01-01', // Date marking start of annotation. Determines y trigger start position on deskop and order
        end_date: '1943-08-31', // Date marking end of annotation. Determines y trigger end position on deskop
        text: 'Dust Bowl: Drought hit most of the U.S. in the 1930s, but the farmers and ranchers of the Great Plains were hit hardest. Not enough rain combined with too much farming and grazing made the top layer of soil loose and dry. Heavy winds blew the dry soil into massive dust storms, which is why we call this period in history the “dust bowl.” The drought ended in 1941, but the lessons learned from the dust bowl continue to shape the farming and grazing practices we use today. </a>', // Narrative text
      },
      {
        id: '1950s_1',
        start_date: '1952-11-01',
        end_date: '1959-08-31',
        text: '1950s Drought: The drought of the 1950s was the biggest in terms of area of land affected. About 80% of hydrologic units (areas of connected streams) received less than half the normal amount of precipitation (<a href="https://doi.org/10.1002/joc.7904" target="_blank">McCabe et al. 2022</a>). The lessons learned from the dust bowl helped people prepare for and respond to the drought, but farmers and ranchers still experienced great hardship, especially in already dry areas like Texas. Texas developed its modern approach to water planning because of how badly the 1950s drought hurt its rural communities.'
      },
      {
        id: '1960s_1',
        start_date: '1962-12-01',
        end_date: '1970-10-31',
        text: '1960s Drought: The 1960s drought was the most severe drought to hit the northeastern U.S. in the last 100 years. The northeastern states did not have experience with droughts, so their emergency reserves of water were not large enough to cover a long dry period. As the region drained its water reserves, the concentration of hazardous pollutants in the water went up, making the remaining water less safe to use. The northeastern states and federal agencies worked together to develop new water conservation and management policies, which provided some relief until the rains returned.'
      },
      {
        id: '1980s_1',
        start_date: '1987-05-01',
        end_date: '1994-10-31',
        text: '1980s Drought: The 1980s drought affected areas from northern Minnesota to southern California. In the summer of 1988, streamflow in the Mississippi River was so low that barges could not go up and down the lower section of the river. That same summer, wildfires burned 36% of Yellowstone National Park, triggering the largest fire-fighting effort in the U.S. at that time. A study in 1989 called for better climate data and predictions to help people prepare for and respond to drought (<a href="https://doi.org/10.1175/1520-0477(1989)070%3C1092:TDBAD%3E2.0.CO;2" target="_blank">Changnon 1989</a>). To this day, USGS scientists are working hard to address that need (<a href="https://www.usgs.gov/mission-areas/water-resources/science/drought-prediction-science" target="_blank">Drought Prediction Science Website</a>).'
      },
      {
        id: 'turn_of_century_1',
        start_date: '1999-09-01',
        end_date: '2017-09-30',
        text: 'Turn-of-the-Century Drought: The turn-of-the-century drought is one of the worst droughts to hit the southwestern U.S. in the last 1200 years. Like previous droughts, low amounts of rain led to big drops in available water. But high temperatures drove the loss of soil moisture during this most recent drought (<a href="https://doi.org/10.1002/joc.7904" target="_blank">McCabe et al. 2022</a>). The national-level drought event ended in 2015, but the turn-of-the-century drought in the southwestern U.S. has continued, earning it the title of “megadrought.” The USGS is working with partners to understand this ongoing megadrought and to predict and communicate drought risk (<a href="https://www.usgs.gov/media/videos/image-week-lake-powell-and-megadrought" target="_blank">Video of drought at Lake Powell</a>).'
      }       
    ]
};