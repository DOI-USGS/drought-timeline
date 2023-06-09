export default {
    timelineEvents: [
      {
        id: '1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by date
        date: '1923-04-01', // Date marking start of annotation. Determines y placement on deskop and mobile AND scroll order for annotations on mobile
        text: 'Event 1: 4/1/1923', // Text of annotation
        desktop_x_offset_per: 60, // x placement on desktop, as percent  of chart width
        desktop_text_anchor: 'start', // alignment of text on desktop (either 'start', 'middle', or 'end')
        desktop_text_width: 100, // Max width allowed for text wrapping
      },
      {
        id: '4',
        date: '1980-06-01',
        text: 'Event 4: 6/1/1980',
        desktop_x_offset_per: 20,
        desktop_text_anchor: 'start',
        desktop_text_width: 100
      },
      {
        id: '5',
        date: '2012-12-01',
        text: 'Event 5: 12/1/2012',
        desktop_x_offset_per: 65,
        desktop_text_anchor: 'start',
        desktop_text_width: 100
      },
      {
        id: '3',
        date: '1965-03-10',
        text: 'Event 3: 3/10/1965',
        desktop_x_offset_per: 75,
        desktop_text_anchor: 'start',
        desktop_text_width: 100
      },
      {
        id: '2',
        date: '1924-09-01',
        text: 'Longest drought on record, lasted 705 days!',
        desktop_x_offset_per: 59,
        desktop_text_anchor: 'start',
        desktop_text_width: 100
      },
      {
        id: 'intro_text_1',
        date: '1922-07-01',
        text: 'Each drought event at a single stream site is represented by a vertical bar. The taller the bar, the longer the drought',
        desktop_x_offset_per: 6,
        desktop_text_anchor: 'start',
        desktop_text_width: 340
      },
      {
        id: 'intro_text_3',
        date: '1933-07-01',
        text: 'When many sites are experiencing drought at the same time, the chart is really wide',
        desktop_x_offset_per: 6,
        desktop_text_anchor: 'start',
        desktop_text_width: 400
      },
      {
        id: 'intro_text_2',
        date: '1924-06-01',
        text: 'This drought was 126 days long',
        desktop_x_offset_per: 40,
        desktop_text_anchor: 'end',
        desktop_text_width: 370
      }      
    ]
};