source('3_visualize/src/plot_stripswarm.R')
source('3_visualize/src/plot_inset.R')
source('3_visualize/src/plot_radial.R')


p3_targets <- list(

  
  # Color scheme tibble
  tar_target(
    p3_colors,
    tibble(
      drought_period_shading = "#F1F1F1", #light orange option: "#DAA520"
      drought_event_color = "#CC5500", # another more subtle orange: "#dd8e58"
      annotation_grey = "#949494"
    )
  ),

  # Generate vertical plot
  tar_target(
    p3_drought_swarm_plot_compressed_vertical,
    event_swarm_plot_compressed_vertical(swarm_data = p2_drought_swarm_compressed)
  ),
  tar_target(p3_drought_swarm_compressed_vertical_png,
             ggsave('src/assets/images/duration-chart/swarm_jd7d_2pct_compressed_vertical.png', 
                    p3_drought_swarm_plot_compressed_vertical,
                    width = 10, height = 100, dpi = 300, limitsize = FALSE),
             format = "file" ),

  # set projection
  tar_target(p2_proj,
             '+proj=aea +lat_0=23 +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs'
             ),

  # transform to sf by filtering metadata to the unique StaID's for states that have the 2000 most severe droughts
  tar_target(p2_metadata_sf,
             sf::st_as_sf(p2_metadata |> 
                            filter(StaID %in% unique(p2_2000_severe_2pct_droughts$StaID)), 
                          coords = c("LNG_GAGE", "LAT_GAGE"), crs = 4269) |> 
               st_transform(p2_proj)),

  # obtain all US wide data 
  tar_target(p2_states,
             spData::us_states |> st_transform(p2_proj) |> ms_simplify(keep = 0.5)),
  

  # plotting inset with stations
  tar_target(p3_inset_stations_map_png,
           plot_inset(station_data = p2_metadata_sf,
                      station = TRUE,
                      us_data = p2_states,
                      regions = FALSE,
                      region_sf = NA,
                      file_png = 'src/assets/images/states_stations_inset.png',
                      width = 16, height = 9,
                      color_scheme = p3_colors),
           format = "file"),
  
  # create CASC-level violins
  tar_target(p3_drought_violin_vertical_byCASC,
             event_violin_vertical(drought_data = p2_expanded_2000_2pct_droughts_byCASC),
             pattern = map(p2_expanded_2000_2pct_droughts_byCASC),
             format = "file"),
  # create CASC-level violin thumbnails (no axes)
  tar_target(p3_drought_barcode_byCASC,
             event_barcode_plot(drought_data = p2_2000_severe_2pct_droughts_byCASC),
             pattern = map(p2_2000_severe_2pct_droughts_byCASC),
             format = "file"),
  
  # plotting inset with stations and regions
  tar_target(p3_inset_stations_map_byCASC_png,
             plot_inset(station_data = p2_metadata_sf |> 
                          filter(STATE %in% p2_expanded_2000_2pct_droughts_byCASC$STATE),
                        station = FALSE,
                        us_data = p2_states,
                        regions = TRUE,
                        region_sf = p2_states |>
                          left_join(p2_CASCs, by = "NAME") |>
                          group_by(CASC) |>
                          summarise(id = unique(CASC)) |> 
                          filter(CASC == unique(p2_expanded_2000_2pct_droughts_byCASC$CASC)),
                        file_png = sprintf("src/assets/images/states_stations_%s.png", 
                                           unique(p2_expanded_2000_2pct_droughts_byCASC$CASC)),
                        width = 9, height = 6,
                        color_scheme = p3_colors),
             pattern = map(p2_expanded_2000_2pct_droughts_byCASC),
             format = "file"),
  
  # plotting inset without stations and all regions
  tar_target(p3_inset_regions_map_allCASC_png,
             plot_inset(station_data = p2_metadata_sf,
                        station = FALSE,
                        us_data = p2_states,
                        regions = TRUE,
                        region_sf = p2_states |>
                          left_join(p2_CASCs, by = "NAME") |>
                          group_by(CASC) |>
                          summarise(id = unique(CASC)),
                        file_png = "src/assets/images/casc_regions_map.png",
                        width = 9, height = 6,
                        color_scheme = p3_colors),
             format = "file"),
  
  # plotting radial thumbnail plot
  tar_target(p3_polar_background_plot_png,
             plot_radial_chart(major_drought_periods = p2_major_droughts_expanded,
                               drought_events = p2_expanded_2000_2pct_droughts_byCASC,
                               color_scheme = p3_colors),
             format = "file")
)
