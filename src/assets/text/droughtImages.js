export default {
    timelineEvents: [
        {
            id: 'dustbowl_image_1', // Unique id for image - order and # value don't matter - images are later sorted by date
            date: '1930-08-01', // Date marking start of period image is shown. Determines y placement AND scroll order
            url: 'https://upload.wikimedia.org/wikipedia/commons/d/db/Dust-storm-Texas-1935_%28cropped%29.png',// url for image source
            alt: 'Image of dust storm', // alt text for image
            desktop_x_offset_per: 7, //x placement of image, as percent of chart width (0 = left edge, 100 = right edge)
            desktop_width_per: 30, // width of image, as percentage of chart width
            mobile_x_offset_per: 63, // x placement of image on mobile
            mobile_width_per: 35 // width of image on mobile
        },
        {
            id: '1950s_image_1',
            date: '1954-06-01',
            url: 'https://upload.wikimedia.org/wikipedia/commons/9/91/Texas_1950s_drought.jpg',
            alt: 'Image of cracked earth in Texas',
            desktop_x_offset_per: 73,
            desktop_width_per: 25,
            mobile_x_offset_per: 73,
            mobile_width_per: 25
        },
        {
            id: '1980s_image_1',
            date: '1987-11-01',
            url: 'https://upload.wikimedia.org/wikipedia/commons/9/95/Corn_shows_the_affect_of_drought.jpg',
            alt: 'Dried-up corn',
            desktop_x_offset_per: 7,
            desktop_width_per: 30,
            mobile_x_offset_per: 67,
            mobile_width_per: 30
        }
    ]
}