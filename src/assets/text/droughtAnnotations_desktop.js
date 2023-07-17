export default {
    timelineEvents: [
      {
        id: 'dustbowlQuote', // Unique id for annotation - order and # value don't matter - annotations are later sorted by date
        date: '1935-04-01', // Date marking start of annotation. Determines y placement on deskop
        text: '"Dust to eat, and dust to breathe and dust to drink. Dust in the beds and in the flour bin, on dishes and walls and windows, in hair and eyes and ears and teeth and throats, to say nothing of the heaped up accumulation on floors and window sills after one of the bad days." - Letter from Caroline Henderson to Secretary of Agriculture Henry A. Wallace, 1935', // Text of annotation
        url: "https://vigilantpostergirl.com/2021/03/01/7-descriptive-dust-bowl-quotes-by-caroline-henderson/", // Required for quote
        quote: true, // required for quote, for styling
        desktop_x_offset_per: 60, // x placement on desktop, as percent  of chart width
        desktop_text_anchor: 'start', // alignment of text on desktop (either 'start', 'middle', or 'end')
        desktop_text_width: 350, // Max width allowed for text wrapping
      },
      {
        id: '1950sQuote',
        date: '1955-01-01',
        text: '“It started out west. It tended to get dry out there and not rain, and that lack of rainfall just moved east. My dad kept saying, ‘We have these things; they’ll just go about eighteen months. It’ll break.’ But that’s what caught everybody off guard: it didn’t break. It just kept on going, and it lasted about seven years.” - Mort Mertz, West Texas rancher since 1954',
        url: 'https://www.texasmonthly.com/articles/when-the-sky-ran-dry/',
        quote: true,
        desktop_x_offset_per: 5,
        desktop_text_anchor: 'start',
        desktop_text_width: 350
      },
      {
        id: '1980sQuote',
        date: '1988-12-01',
        text: '"1988 will be remembered as the Year of the Drought.” - Minnesota Department of Natural Resources, Division of Waters, 1989',
        quote: true,
        url: 'https://files.dnr.state.mn.us/natural_resources/climate/summaries_and_publications/drought1988.pdf',
        desktop_x_offset_per: 65,
        desktop_text_anchor: 'start',
        desktop_text_width: 350
      },
      {
        id: '1960sQuote',
        date: '1965-03-01',
        text: '“The unusually long and severe water shortages in the Northeast during the 1960s emphasized the fact that drought is a national problem, and is not limited to any single geographic region or climate.” - Henry C. Barksdale, 1968',
        quote: true,
        url: 'https://www.usgs.gov/publications/northeast-water-supply-crisis-1960s',
        desktop_x_offset_per: 65,
        desktop_text_anchor: 'start',
        desktop_text_width: 350
      },
      {
        id: 'tocQuote',
        date: '2000-04-01',
        text: '“2000-2021 ranks as the driest 22-year period since at least 800 CE.” - A. Park Williams, Benjamin I. Cook, and Jason E. Smerdon, 2022',
        quote: true,
        url: 'https://www.nature.com/articles/s41558-022-01290-z',
        desktop_x_offset_per: 10,
        desktop_text_anchor: 'start',
        desktop_text_width: 350
      },
      {
        id: 'quoteTOC2',
        date: '2014-02-21',
        text: '"Twenty-two years in, some of these big megadroughts in the past were starting to peter out. This drought is not petering out. Instead, it is in full swing and is as strong now as it ever was before." - A. Park Williams, 2022',
        url: 'https://www.nbcnews.com/science/environment/us-megadrought-worst-least-1200-years-researchers-say-rcna16202',
        quote: true,
        desktop_x_offset_per: 10,
        desktop_text_anchor: 'start',
        desktop_text_width: 350
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
        date: '1923-07-01',
        text: 'Where the chart is wider, many streamgages were experiencing drought simultaneously.',
        desktop_x_offset_per: 56,
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
      },
      {
        id: 'legend',
        date: '1926-06-01',
        text: 'Droughts are colored by duration where darker = longer.',
        desktop_x_offset_per: 58,
        desktop_text_anchor: 'start',
        desktop_text_width: 370
      }    ,
      {
        id: 'legend-2',
        date: '1927-04-01',
        text: 'The shortest droughts were 43 days',
        desktop_x_offset_per: 58,
        desktop_text_anchor: 'start',
        desktop_text_width: 370
      }   
    ]
};