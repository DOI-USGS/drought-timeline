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
  
# plotting inset
  tar_target(p3_inset_map,
             plot_inset(station_data = p2_prop_western_2_StaID_metadata_sf,
                        western_us_data = p2_states_western,
                        us_data = p2_states)),
  tar_target(p3_inset_map_png,
             ggsave('3_visualize/out/western_states_inset.png', 
                    p3_inset_map,
                    width = 10, height = 10, dpi = 300, bg = "transparent", limitsize = FALSE),
             format = "file" )
  
)
