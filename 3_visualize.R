source('3_visualize/src/plot_stripswarm.R')
source('3_visualize/src/plot_inset.R')
source('3_visualize/src/plot_radial.R')
source('3_visualize/src/cowplot_viz.R')


p3_targets <- list(
  # supporting font
  tar_target(
    p3_supporting_font,
    {
      supporting_font <- "Source Sans Pro"
      sysfonts::font_add_google(supporting_font)
      showtext::showtext_opts(dpi = 300, regular.wt = 200, bold.wt = 900)
      showtext::showtext_auto(enable = TRUE)
      return(supporting_font)
    }
  ),
  tar_target(
    p3_fancy_font,
    {
      fancy_font <- "Gochi Hand"
      sysfonts::font_add_google(fancy_font)
      showtext::showtext_opts(dpi = 300, regular.wt = 200, bold.wt = 900)
      showtext::showtext_auto(enable = TRUE)
      return(fancy_font)
    }
  ),
  
  # Color scheme tibble
  tar_target(
    p3_colors,
    tibble(
      drought_period_shading = "#F1F1F1", #light orange option: "#DAA520"
      drought_event_dark = "#C34C4A", 
      drought_event_highlight = "#E48951",
      annotation_grey = "#949494",
      dark_grey = "#6B6B6B",
      light_grey = "#ADADAD"
      # colors in the main stripswarm from: scico(n = 5, palette = "lajolla", begin = 0.25)
      #c("#F1C659", "#E48951", "#C34C4A", "#69342A", "#191900")
    )
  ),

  # Generate vertical plot
  tar_target(
    p3_drought_swarm_plot_compressed_vertical,
    event_swarm_plot_compressed_vertical(swarm_data = p2_drought_swarm_compressed)
  ),
  tar_target(p3_drought_swarm_compressed_vertical_png,
             ggsave('src/assets/images/duration-chart/swarm_jd7d_compressed_vertical.png', 
                    p3_drought_swarm_plot_compressed_vertical,
                    width = 10, height = 100, dpi = 300, limitsize = FALSE),
             format = "file" ),

  # set projection
  tar_target(p3_proj,
             '+proj=aea +lat_0=23 +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs'
             ),

  # transform to sf by filtering metadata to the unique StaID's for states that have the 2000 most severe droughts
  tar_target(p3_metadata_sf,
             sf::st_as_sf(p2_metadata |> 
                            filter(StaID %in% unique(p2_2000_severe_droughts$StaID)), 
                          coords = c("LNG_GAGE", "LAT_GAGE"), crs = 4269) |> 
               st_transform(p3_proj)),
  tar_target(p3_metadata_allStations_sf,
             sf::st_as_sf(p2_metadata, 
                          coords = c("LNG_GAGE", "LAT_GAGE"), crs = 4269) |> 
               st_transform(p3_proj)),

  # obtain all US wide data 
  tar_target(p3_states,
             spData::us_states |> st_transform(p3_proj) |> ms_simplify(keep = 0.5)),
  
  # Build regions by spatially grouping together states by CASC
  tar_target(p3_CASCs_sf,
             p3_states |>
               left_join(p2_CASCs, by = "NAME") |>
               group_by(CASC) |>
               summarise(id = unique(CASC)) |>
               st_cast("MULTIPOLYGON") |>
               st_cast("POLYGON")
             ),

  # plotting inset with stations
  tar_target(p3_inset_stations_map_png,
             plot_inset(station = TRUE,
                        station_data = p3_metadata_sf,
                        us_data = p3_states,
                        regions = FALSE,
                        region_sf = NA,
                        focal_stations = FALSE,
                        focal_station_data = NA,
                        file_out = 'src/assets/images/states_stations_inset.png',
                        svg_export = FALSE,
                        width = 13, height = 7,
                        color_scheme = p3_colors),
             format = "file"),
  # plotting inset with by time frame
  tar_target(p3_inset_stations_map1921_png,
             plot_inset(station = TRUE,
                        station_data = p3_metadata_allStations_sf |> filter(national_1921),
                        us_data = p3_states,
                        regions = FALSE,
                        region_sf = NA,
                        focal_stations = FALSE,
                        focal_station_data = p3_metadata_sf |> filter(national_1921),
                        file_out = 'src/assets/images/states_stations_inset1921.png',
                        svg_export = FALSE,
                        width = 13, height = 7,
                        color_scheme = p3_colors),
             format = "file"),
  tar_target(p3_inset_stations_map1951_png,
             plot_inset(station = TRUE,
                        station_data = p3_metadata_allStations_sf |> filter(national_1951),
                        us_data = p3_states,
                        regions = FALSE,
                        region_sf = NA,
                        focal_stations = FALSE,
                        focal_station_data = p3_metadata_sf |> filter(national_1951),
                        file_out = 'src/assets/images/states_stations_inset1951.png',
                        svg_export = FALSE,
                        width = 13, height = 7,
                        color_scheme = p3_colors),
             format = "file"),
  tar_target(p3_inset_stations_map1981_png,
             plot_inset(station = TRUE,
                        station_data = p3_metadata_allStations_sf |> filter(national_1981),
                        us_data = p3_states,
                        regions = FALSE,
                        region_sf = NA,
                        focal_stations = FALSE,
                        focal_station_data = p3_metadata_sf |> filter(national_1981),
                        file_out = 'src/assets/images/states_stations_inset1981.png',
                        svg_export = FALSE,
                        width = 13, height = 7,
                        color_scheme = p3_colors),
             format = "file"),
  
  # create CASC-level violins
  tar_target(p3_drought_violin_vertical_byCASC_png,
             event_violin_vertical(drought_data = p2_expanded_2000_droughts_byCASC,
                                   major_drought_periods = p2_major_droughts_expanded_radial,
                                   # add these in manually so that the y-scale has 1920 and 2020 by 5 yrs
                                   timeline_start = "1920-01-01",
                                   timeline_end = "2020-12-31",
                                   supporting_font = p3_supporting_font,
                                   color_scheme = p3_colors,
                                   file_out = sprintf("src/assets/images/duration-chart/vertical_violin_jd7d_%s.png", 
                                                      gsub(' ', '-', unique(p2_expanded_2000_droughts_byCASC$CASC)))),
             pattern = map(p2_expanded_2000_droughts_byCASC),
             format = "file"),

  
  # plotting inset by region
  tar_target(p3_inset_regions_map_byCASC_png,
             plot_inset(station = FALSE,
                        station_data = NA,
                        us_data = p3_states,
                        regions = TRUE,
                        region_sf = p3_CASCs_sf |> 
                          filter(CASC == unique(p2_expanded_2000_droughts_byCASC$CASC)),
                        focal_stations = FALSE,
                        focal_station_data = NA,
                        file_out = sprintf("src/assets/images/states_regions_%s.png", 
                                           gsub(' ', '-', unique(p2_expanded_2000_droughts_byCASC$CASC))),
                        svg_export = FALSE,
                        width = 9, height = 6,
                        color_scheme = p3_colors),
             pattern = map(p2_expanded_2000_droughts_byCASC),
             format = "file"),
  
  # plotting inset with for major drought periods
  tar_target(p3_inset_stations_map_byMajorDrought_png,
             plot_inset(station = TRUE,
                        station_data = p3_metadata_sf,
                        us_data = p3_states,
                        regions = FALSE,
                        region_sf = NA,
                        focal_stations = TRUE,
                        focal_station_data = p3_metadata_sf |> 
                          filter(StaID %in% p2_expanded_droughts_during_major_drought_periods$StaID),
                        file_out = sprintf("src/assets/images/drought_period_stations_%s.png", 
                                           unique(p2_expanded_droughts_during_major_drought_periods$major_drought_id)),
                        svg_export = FALSE,
                        width = 13, height = 7,
                        color_scheme = p3_colors),
             pattern = map(p2_expanded_droughts_during_major_drought_periods),
             format = "file"),
  
  # plotting inset without stations and all regions
  tar_target(p3_inset_regions_map_allCASC_png,
             plot_inset(station = FALSE,
                        station_data = NA,
                        us_data = p3_states,
                        regions = TRUE,
                        region_sf = p3_CASCs_sf,
                        focal_stations = FALSE,
                        focal_station_data = NA,
                        file_out = "src/assets/images/casc_regions_map.png",
                        svg_export = FALSE,
                        width = 9, height = 6,
                        color_scheme = p3_colors),
             format = "file"),
  # plotting inset without stations and all regions in SVG
  tar_target(p3_inset_regions_map_allCASC_svg,
             plot_inset(station = FALSE,
                        station_data = NA,
                        us_data = p3_states,
                        regions = TRUE,
                        region_sf = p3_CASCs_sf,
                        focal_stations = FALSE,
                        focal_station_data = NA,
                        file_out = "src/assets/svgs/casc_regions_map.svg",
                        svg_export = TRUE,
                        width = 9, height = 6,
                        color_scheme = p3_colors),
             format = "file"),
  
  # plotting radial thumbnail plot
  tar_target(p3_CASC_angles,
             tibble(CASC = unique(p2_CASCs$CASC)) %>%
               # these angles are set ~51.4 degrees apart starting at Midwest for polar plot
               mutate(CASC_angle = case_when(CASC == "Midwest" ~ 26.5,
                                               CASC == "Northeast" ~ 79.5,
                                               CASC == "Southeast" ~ 132.5,
                                               CASC == "South Central" ~ 185.5,
                                               CASC == "Southwest" ~ 238.5,
                                               CASC == "Northwest" ~ 291.5,
                                               CASC == "North Central" ~ 344.5))),
  tar_target(p3_polar_violin_plot_png,
             plot_radial_chart(major_drought_periods = p2_major_droughts_expanded_radial,
                               drought_events = p2_expanded_2000_droughts_byCASC,
                               CASC_angles = p3_CASC_angles,
                               supporting_font = p3_supporting_font,
                               color_scheme = p3_colors,
                               file_out = "src/assets/images/duration-chart/polar_background_plot.png"),
             format = "file"),
  
  # plotting radial plot with wedges to svg 
  tar_target(p3_polar_wedge_plot_svg,
             plot_radial_wedges(CASC_angles = p3_CASC_angles,
                                supporting_font = p3_supporting_font,
                                file_out = "src/assets/svgs/polar_wedges.svg"),
             format = "file"),
  
  # Creating CASC viz for social media
  tar_target(p3_CASC_swarms_png,
             casc_swarms(file_out = sprintf("3_visualize/out/swarm_%s.png", 
                                                   gsub(' ', '-', unique(p2_CASCs_pattern$CASC))),
                                drought_data = p2_drought_swarm_compressed_byCASC |>
                                  filter(CASC == unique(p2_CASCs_pattern$CASC)),
                                major_drought_periods = p2_major_droughts_expanded_radial,
                                # add these in manually so that the y-scale has 1920 and 2020 by 5 yrs
                                timeline_start = "1920-01-01",
                                timeline_end = "2020-12-31",
                                supporting_font = p3_supporting_font,
                                color_scheme = p3_colors),
             pattern = map(p2_CASCs_pattern),
             format = "file"),
  tar_target(p3_instagram_CASCs_png,
             casc_viz_instagram(file_out = sprintf("3_visualize/out/instagram_release_%s.png", 
                                                   gsub(' ', '-', unique(p2_CASCs_pattern$CASC))),
                                casc_name = unique(p2_CASCs_pattern$CASC),
                                swarm_pngs = p3_CASC_swarms_png,
                                # add these in manually so that the y-scale has 1920 and 2020 by 5 yrs
                                timeline_start = "1920-01-01",
                                timeline_end = "2020-12-31",
                                supporting_font = p3_supporting_font,
                                fancy_font = p3_fancy_font,
                                color_scheme = p3_colors),
             pattern = map(p2_CASCs_pattern, p3_CASC_swarms_png),
             format = "file")
)
