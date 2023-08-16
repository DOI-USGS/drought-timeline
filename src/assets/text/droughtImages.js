export default {
    timelineEvents: [
        {
            id: 'dustbowl_image_1', // Unique id for image - order and # value don't matter - images are later sorted by date
            date: '1930-08-01', // Date marking start of period image is shown. Determines y placement AND scroll order
            url: 'https://www.loc.gov/resource/fsa.8b38290/',
            name: 'drought_1930.png',
            alt: 'Results of a dust storm in Cimarron County, Oklahoma, in 1936. A dilapidated wooden building and parts of a wagon sit buried in dust after a dust storm, with bare trees and a windmill in the background.', // alt text for image
            mobile_x_offset_per: 65, // x placement of image on mobile
            mobile_width_per: 30 // width of image on mobile
        },
        {
            id: '1950s_image_1',
            date: '1954-03-11',
            url: 'https://www.tsl.texas.gov/lobbyexhibits/water-droughts',
            name: 'drought_1952.png',
            alt: 'Deep cracks run through a large area of dry earth, with trees and a rocky plateau in the distance.',
            mobile_x_offset_per: 73,
            mobile_width_per: 20
        },
        {
            id: '1960s_image_1',
            date: '1963-02-01',
            url: 'https://broadleafpapers.wordpress.com/the-broadleaf-papers/archived-posts/golden-anniversary-of-the-drought-most-northeasterners-have-forgotten-intro/',
            name: 'drought_1962.png',
            alt: 'A large area of shoreline is exposed in a reservoir in Massachusetts, revealing old tree stumps and other debris. A sign on the shore reads, “Elevation 498.17,” and trees and hills are visible in the distance.',
            mobile_x_offset_per: 73,
            mobile_width_per: 22
        },
        {
            id: '1980s_image_1',
            date: '1987-08-01',
            url: 'https://www.flickr.com/photos/wolfriver/409499930/',
            name: 'drought_1987.png',
            alt: 'People explore the wreckages of wooden-hulled boats exposed by low water levels in the Mississippi River. The river is visible in the distance, along with a bridge and a shoreline with buildings and trees.',
            mobile_x_offset_per: 73,
            mobile_width_per: 25
        },
        {
            id: 'turnofcentury_image_1',
            date: '1999-11-01',
            url: 'https://www.usgs.gov/media/images/california-drought-huntington-lake-august-2014',
            name: 'drought_1999.png',
            alt: 'Extremely low water levels in a lake in California leave wooden floating docks stranded on land, far from the edge of the water. A small amount of water is visible beyond the shoreline, and trees cover the hills on the other side of the lake.',
            mobile_x_offset_per: 75,
            mobile_width_per: 22
        },
        {
            id: 'turnofcentury_image_2',
            date: '2012-07-01',
            url: 'https://www.usgs.gov/media/images/usgs-documents-2015-western-us-drought-0',
            name: 'drought_1922.png',
            alt: 'A hydrologic technician from the USGS Idaho Water Science Center measures streamflow in Lightning Creek at Clark Fork, ID. The riverbed is almost completely dry, showing exposed rocks. The technician stands on the dry riverbed, measuring a small trickle of water through the rocks. The background shows a bridge and surrounding forest.',
            mobile_x_offset_per: 65,
            mobile_width_per: 30
        }
    ]
}