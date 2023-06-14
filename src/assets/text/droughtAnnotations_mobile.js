export default {
    timelineEvents: [
      {
        id: '1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by date
        date: '1926-06-01', // Date marking start of annotation. Determines y placement on mobile AND scroll order for annotations on mobile
        text: '<a href="https://en.wikipedia.org/wiki/Dust_Bowl" target="_blank">"This is a quote about drought"</a>', // Text of annotation
        quote: true, // required for quote, for styling
        mobile_x_offset_per: 30 // x placement of circle on mobile, as percent of chart width (0 = left edge, 100 = right edge)
      },
      {
        id: '4',
        date: '1980-06-01',
        text: 'Event 4: 6/1/1980',
        mobile_x_offset_per: 20
      },
      {
        id: '5',
        date: '2012-12-01',
        text: 'Event 5: 12/1/2012',
        mobile_x_offset_per: 20
      },
      {
        id: '3',
        date: '1968-03-10',
        text: 'Event 3: 3/10/1968',
        mobile_x_offset_per: 80
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
        text: 'Each drought event at a single stream site is represented by a vertical bar. The taller the bar, the longer the drought',
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
        text: 'dustbowl text 1 <a href="https://en.wikipedia.org/wiki/Dust_Bowl" target = "_blank">source</a>',
        mobile_x_offset_per: 24
      },
      {
        id: '1950s_1',
        date: '1953-04-01',
        text: '1950s drought text 1',
        mobile_x_offset_per: 28
      } ,
      {
        id: '1950s_2',
        date: '1956-06-01',
        text: '1950s drought text 2',
        mobile_x_offset_per: 15
      },
      {
        id: 'dustbowl_2',
        date: '1936-01-01',
        text: 'dustbowl text 2',
        mobile_x_offset_per: 15
      },
      {
        id: '1960s_1',
        date: '1963-05-01',
        text: '1960s drought text 1',
        mobile_x_offset_per: 27
      },
      {
        id: '1960s_2',
        date: '1966-11-01',
        text: '1960s drought text 2',
        mobile_x_offset_per: 15
      },
      {
        id: '1980s_1',
        date: '1987-09-15',
        text: '1980s drought text 1',
        mobile_x_offset_per: 27
      },
      {
        id: 'turn_of_century_1',
        date: '2000-03-15',
        text: 'Turn-of-the-Century Drought text 1',
        mobile_x_offset_per: 25
      },
      {
        id: 'end',
        date: '2019-04-01',
        text: 'end of timeline',
        mobile_x_offset_per: 15
      }    
    ]
};