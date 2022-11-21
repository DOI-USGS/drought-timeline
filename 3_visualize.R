source('3_visualize/src/plot_stripswarm.R')
source('3_visualize/src/plot_inset.R')


p3_targets <- list(
  # Generate plot where each drought day (unique site day with drought)
  # is a single tile of width 1
  tar_target(
    p3_prop_western_2_swarm_plot,
    event_swarm_plot(swarm_data = p2_prop_western_2_swarm)
  ),
  tar_target(p3_prop_western_2_swarm_png,
             ggsave('src/assets/images/duration-chart/swarm_jd7d_2_western.png', 
                    p3_prop_western_2_swarm_plot,
                    width = 100, height = 10, dpi = 300, limitsize = FALSE),
             format = "file" ),
  
  # Generate plot where each drought event (unique drought at a single site)
  # is a single tile with width equal to the duration of the drought event
  tar_target(
    p3_prop_western_2_swarm_plot_compressed,
    event_swarm_plot_compressed(swarm_data = p2_prop_western_2_swarm_compressed)
  ),
  tar_target(p3_prop_western_2_swarm_compressed_png,
             ggsave('src/assets/images/duration-chart/swarm_jd7d_2_western_compressed.png', 
                    p3_prop_western_2_swarm_plot_compressed,
                    width = 100, height = 10, dpi = 300, limitsize = FALSE),
             format = "file" ),
  
  # Generate vertical plot
  tar_target(
    p3_prop_western_2_swarm_plot_compressed_vertical,
    event_swarm_plot_compressed_vertical(swarm_data = p2_prop_western_2_swarm_compressed)
  ),
  tar_target(p3_prop_western_2_swarm_compressed_vertical_png,
             ggsave('src/assets/images/duration-chart/swarm_jd7d_2_western_compressed_vertical.png', 
                    p3_prop_western_2_swarm_plot_compressed_vertical,
                    width = 10, height = 100, dpi = 300, limitsize = FALSE),
             format = "file" ),

# set proj
  tar_target(p2_proj,
             '+proj=aea +lat_0=23 +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs'
             ),

# transform to sf by filter metadataing to the unique staID's for western states that have threshold =2 
  tar_target(p2_prop_western_2_StaID_metadata_sf,
             sf::st_as_sf(p2_1951_2020_metadata |> filter(StaID %in% unique(p2_prop_western_2$StaID)), coords = c("LNG_GAGE", "LAT_GAGE"), crs = 4269) |> 
               st_transform(p2_proj)),

# obtain all US wide data 
  tar_target(p2_states,
             spData::us_states |> st_transform(p2_proj) |> ms_simplify(keep = 0.5)),

# filter US for the 11 western states of interest 
tar_target(p2_states_western,
           p2_states |> 
             filter(NAME %in% c('Arizona', 'California', 'Colorado', 'Idaho', 'Montana', 'Nevada','New Mexico', 'Oregon', 'Utah','Washington', 'Wyoming'))),

# plotting inset with stations
  tar_target(p3_inset_stations_map,
           plot_inset(station_data = p2_prop_western_2_StaID_metadata_sf,
                      station = TRUE,
                      western_us_data = p2_states_western,
                      us_data = p2_states,
                      file_png = 'src/assets/images/western_states_stations_inset.png',
                      width = 16, height = 9),
           format = "file"),

# plotting inset without stations
tar_target(p3_inset_map,
           plot_inset(station_data = p2_prop_western_2_StaID_metadata_sf,
                      station = FALSE,
                      western_us_data = p2_states_western,
                      us_data = p2_states,
                      file_png = 'src/assets/images/western_states_inset.png',
                      width = 16, height = 9),
           format = "file")
)
