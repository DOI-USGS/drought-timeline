export default {
    timelineEvents: [
      {
        id: 'quote_dustbowl', // Unique id for annotation - order and # value don't matter - annotations are later sorted by date
        date: '1934-06-01', // Date marking start of annotation. Determines y placement on mobile AND scroll order for annotations on mobile
        text: '"Dust to eat, and dust to breathe and dust to drink. Dust in the beds and in the flour bin, on dishes and walls and windows, in hair and eyes and ears and teeth and throats, to say nothing of the heaped up accumulation on floors and window sills after one of the bad days.” - <a href="https://vigilantpostergirl.com/2021/03/01/7-descriptive-dust-bowl-quotes-by-caroline-henderson/" target="_blank">Letter from Caroline Henderson to Secretary of Agriculture Henry A. Wallace, 1935"</a>', // Text of annotation
        quote: true, // required for quote, for styling
        mobile_x_offset_per: 30 // x placement of circle on mobile, as percent of chart width (0 = left edge, 100 = right edge)
      },
      {
        id: 'quote_1950s',
        date: '1955-06-01',
        text: '“It started out west. It tended to get dry out there and not rain, and that lack of rainfall just moved east. My dad kept saying, ‘We have these things; they’ll just go about eighteen months. It’ll break.’ But that’s what caught everybody off guard: it didn’t break. It just kept on going, and it lasted about seven years.” - <a href="https://www.texasmonthly.com/articles/when-the-sky-ran-dry/" target="_blank">Mort Mertz, West Texas rancher since 1954</a>',
        quote: true,
        mobile_x_offset_per: 20
      },
      {
        id: 'quote_1960s',
        date: '1968-04-01',
        text: '“The unusually long and severe water shortages in the Northeast during the 1960s emphasized the fact that drought is a national problem, and is not limited to any single geographic region or climate.” - <a href="https://www.usgs.gov/publications/northeast-water-supply-crisis-1960s" target="_blank">Henry C. Barksdale, 1968</a>',
        quote: true,
        mobile_x_offset_per: 20
      },
      {
        id: 'quote1980s',
        date: '1992-09-10',
        text: '"1988 will be remembered as the Year of the Drought.” - <a href="https://files.dnr.state.mn.us/natural_resources/climate/summaries_and_publications/drought1988.pdf" target="_blank">Minnesota Department of Natural Resources, Division of Waters, 1989</a>',
        quote: true,
        mobile_x_offset_per: 35
      },
      {
        id: 'quoteTOC',
        date: '2005-01-01',
        text: '“2000-2021 ranks as the driest 22-year period since at least 800 CE.” - <a href="https://www.nature.com/articles/s41558-022-01290-z" target="_blank">A. Park Williams, Benjamin I. Cook, and Jason E. Smerdon, 2022</a>',
        quote: true,
        mobile_x_offset_per: 65
      },
      {
        id: 'quoteTOC2',
        date: '2015-01-01',
        text: '"Twenty-two years in, some of these big megadroughts in the past were starting to peter out. This drought is not petering out. Instead, it is in full swing and is as strong now as it ever was before." - <a href="https://www.nbcnews.com/science/environment/us-megadrought-worst-least-1200-years-researchers-say-rcna16202" target="_blank">A. Park Williams, 2022</a>',
        quote: true,
        mobile_x_offset_per: 40
      },
      {
        id: '2',
        date: '1925-05-01',
        text: 'Longest drought on record, lasted 705 days!',
        mobile_x_offset_per: 61
      },
      {
        id: 'intro_text_1',
        date: '1922-07-01',
        text: 'Each streamflow drought event at a single stream site is represented by a vertical bar. The taller the bar, the longer the drought',
        mobile_x_offset_per: 20
      },
      {
        id: 'intro_text_3',
        date: '1933-07-01',
        text: 'When many sites are experiencing drought at the same time, the chart is really wide',
        mobile_x_offset_per: 25
      },
      {
        id: 'intro_text_2',
        date: '1924-06-01',
        text: 'This drought was 126 days long',
        mobile_x_offset_per: 38
      },
      {
        id: 'dustbowl_1',
        date: '1930-06-01',
        text: 'Drought hit most of the U.S. in the 1930s, but the farmers and ranchers of the Great Plains were hit hardest. Not enough rain combined with too much farming and grazing made the top layer of soil loose and dry. Heavy winds blew the dry soil into massive dust storms, which is why we call this period in history the “dust bowl.”',
        mobile_x_offset_per: 24
      },
      {
        id: 'dustbowl_2',
        date: '1940-06-01',
        text: 'The drought ended in 1941, but the lessons learned from the dust bowl continue to shape the farming and grazing practices we use today. ',
        mobile_x_offset_per: 24
      },
      {
        id: '1950s_1',
        date: '1953-04-01',
        text: 'The drought of the 1950s was the biggest in terms of area of land affected. About 80% of hydrologic units (areas of connected streams) received less than half the normal amount of precipitation (<a href="https://doi.org/10.1002/joc.7904" target="_blank">McCabe et al. 2022</a>).',
        mobile_x_offset_per: 28
      } ,
      {
        id: '1950s_2',
        date: '1957-04-01',
        text: 'The lessons learned from the dust bowl helped people prepare for and respond to the drought, but farmers and ranchers still experienced great hardship, especially in already dry areas like Texas. Texas developed its modern approach to water planning because of how badly the 1950s drought hurt its rural communities.',
        mobile_x_offset_per: 28
      } ,
      {
        id: '1960s_1',
        date: '1963-05-01',
        text: 'The 1960s drought was the most severe drought to hit the northeastern U.S. in the last 100 years. The northeastern states did not have experience with droughts, so their emergency reserves of water were not large enough to cover a long dry period.',
        mobile_x_offset_per: 27
      },
      {
        id: '1960s_2',
        date: '1966-05-01',
        text: 'As the region drained its water reserves, the concentration of hazardous pollutants in the water went up, making the remaining water less safe to use. The northeastern states and federal agencies worked together to develop new water conservation and management policies, which provided some relief until the rains returned.',
        mobile_x_offset_per: 45
      },
      {
        id: '1980s_1',
        date: '1987-09-15',
        text: 'The 1980s drought affected areas from northern Minnesota to southern California. A study in 1989 called for better climate data and predictions to help people prepare for and respond to drought (<a href="https://doi.org/10.1175/1520-0477(1989)070%3C1092:TDBAD%3E2.0.CO;2" target="_blank">Changnon 1989</a>). To this day, USGS scientists are working hard to address that need (<a href="https://www.usgs.gov/mission-areas/water-resources/science/drought-prediction-science" target="_blank">Drought Prediction Science Website</a>).',
        mobile_x_offset_per: 27
      },
      {
        id: '1980s_2',
        date: '1989-09-15',
        text: 'In the summer of 1988, streamflow in the Mississippi River was so low that barges could not go up and down the lower section of the river. That same summer, wildfires burned 36% of Yellowstone National Park, triggering the largest fire-fighting effort in the U.S. at that time.',
        mobile_x_offset_per: 40
      },
      {
        id: 'turn_of_century_1',
        date: '2000-03-15',
        text: 'The turn-of-the-century drought is one of the worst droughts to hit the southwestern U.S. in the last 1200 years. Like previous droughts, low amounts of rain led to big drops in available water. But high temperatures drove the loss of soil moisture during this most recent drought (<a href="https://doi.org/10.1002/joc.7904" target="_blank">McCabe et al. 2022</a>).',
        mobile_x_offset_per: 25
      },
      {
        id: 'turn_of_century_2',
        date: '2007-01-01',
        text: 'The national-level drought event ended in 2015, but the turn-of-the-century drought in the southwestern U.S. has continued, earning it the title of “megadrought.” The USGS is working with partners to understand this ongoing megadrought and to predict and communicate drought risk (<a href="https://www.usgs.gov/media/videos/image-week-lake-powell-and-megadrought" target="_blank">Video of drought at Lake Powell</a>).',
        mobile_x_offset_per: 60
      },
      {
        id: 'legend',
        date: '1926-11-01',
        text: 'Droughts are colored by duration where darker = longer. The shortest droughts were 43 days',
        mobile_x_offset_per: 60
      }   
    ]
};