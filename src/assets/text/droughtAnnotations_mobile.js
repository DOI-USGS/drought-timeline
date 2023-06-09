export default {
    timelineEvents: [
      {
        id: '1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by date
        date: '1922-01-01', // Date marking start of annotation. Determines y placement on mobile AND scroll order for annotations on mobile
        text: 'Event 1: 1/1/1922', // Text of annotation
        mobile_x_offset_per: 20 // x placement of circle on mobile, as percent of chart width (0 = left edge, 100 = right edge)
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
        date: '1965-03-10',
        text: 'Event 3: 3/10/1965',
        mobile_x_offset_per: 20
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
      }      
    ]
};