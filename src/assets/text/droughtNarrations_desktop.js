export default {
    timelineEvents: [
      {
        id: 'dustbowl_1', // Unique id for annotation - order and # value don't matter - annotations are later sorted by start_date
        start_date: '1930-01-01', // Date marking start of annotation. Determines y trigger start position on deskop and order
        end_date: '1935-12-31', // Date marking end of annotation. Determines y trigger end position on deskop
        text: 'dustbowl text 1 <a href="https://en.wikipedia.org/wiki/Dust_Bowl" target = "_blank">source</a>', // Narrative text
      },
      {
        id: '1950s_1',
        start_date: '1952-11-01',
        end_date: '1955-05-31',
        text: '1950s drought text 1'
      },
      {
        id: '1950s_2',
        start_date: '1955-06-01',
        end_date: '1957-08-31',
        text: '1950s drought text 2'
      },
      {
        id: 'dustbowl_2',
        start_date: '1936-01-01',
        end_date: '1941-08-31',
        text: 'dustbowl text 2'
      },
      {
        id: '1960s_1',
        start_date: '1962-12-01',
        end_date: '1965-10-31',
        text: '1960s drought text 1'
      },
      {
        id: '1960s_2',
        start_date: '1965-11-01',
        end_date: '1968-10-31',
        text: '1960s drought text 2'
      },
      {
        id: '1980s_1',
        start_date: '1987-05-01',
        end_date: '1992-10-31',
        text: '1980s drought text 1'
      },
      {
        id: 'turn_of_century_1',
        start_date: '1999-09-01',
        end_date: '2015-09-30',
        text: 'Turn-of-the-Century Drought text 1'
      },
      {
        id: 'end',
        start_date: '2017-03-01',
        end_date: '2020-04-01',
        text: 'end of timeline'
      }          
    ]
};