export default {
    timelineEvents: [
      {
        id: '1970s_1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by start_date
        date: '1974-05-01', // Date marking start of annotation. Determines y trigger start position on deskop and order
        text: 'The 1976-1977 drought was short, so it is not considered one of the five major drought events in the last 100 years. But this two-year drought caused agricultural losses and hydropower shortages across much of the western U.S.', // Narrative text
        desktop_x_offset_per: 10,
        desktop_text_anchor: 'start',
        desktop_text_width: 300
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
        id: 'legend',
        date: '1922-06-01',
        text: 'Droughts are colored by duration where darker = longer',
        desktop_x_offset_per: 14,
        desktop_text_anchor: 'start',
        desktop_text_width: 300
      }    ,
      {
        id: 'legend-2',
        date: '1923-06-01',
        text: 'The shortest droughts were 43 days',
        desktop_x_offset_per: 14,
        desktop_text_anchor: 'start',
        desktop_text_width: 300
      }   
    ]
};