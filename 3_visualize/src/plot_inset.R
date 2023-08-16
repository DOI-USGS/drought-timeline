
plot_inset <- function(station_data, station, us_data, regions, region_sf, focal_stations, focal_station_data, file_out, svg_export, width, height, color_scheme){
  # if exporting as svg, must have polygons instead of multipolygons
  # have to cast to multipolygon first to not lose some polygons
  if (svg_export) {
    us_data <- us_data %>%
      st_cast("MULTIPOLYGON") %>%
      st_cast("POLYGON")
  }
  
  p <- ggplot() + 
    # add state shapes
    geom_sf(data = us_data,
            fill = "white",
            color = NA,
            linewidth = 1.2) +
    theme_void() 
  
  if (regions && !station)
    # add regions with thick borders
    p <- p + geom_sf(data = region_sf,
                     color = 'white',
                     alpha = 0.5,
                     fill = color_scheme$drought_event_highlight,
                     linewidth = 5)
  
  # add state borders
  p <- p + geom_sf(data = us_data,
                   fill = NA,
                   color = color_scheme$light_grey,
                   linewidth = 1)
  
  if (regions && station) 
    # add regions w/o borders
    p <- p + geom_sf(data = region_sf,
                     color = NA,
                     alpha = 0.5,
                     fill = color_scheme$drought_event_dark)
  
  if (station)
    # add stations
    p <- p + geom_sf(data = station_data, shape = 21, 
                     color = "white", fill = "white", 
                     size = 2.2) + 
    geom_sf(data = station_data, shape = 21, 
            color = if (focal_stations) color_scheme$light_grey else color_scheme$dark_grey, 
            fill = if (focal_stations) color_scheme$light_grey else color_scheme$dark_grey, 
            size = 1.4)
  
  if (focal_stations)
    # add focal stations
    p <- p + geom_sf(data = focal_station_data, shape = 21, 
                     color = color_scheme$drought_event_dark, 
                     fill = color_scheme$drought_event_dark, 
                     size = 2.5)
  
  if (!svg_export) {
    ggsave(file_out, width = width, height = height, dpi = 300, bg = "transparent", limitsize = FALSE)
  } else if (svg_export && !station && regions && !focal_stations) {
    
    # gridSVG approach modified from 
    # https://gist.github.com/jimjam-slam/1d988451ae15882c889f49cf20b99a64
    grob <- p %>% ggplotGrob() %>% grid::grid.force()
    dev.new(width = width, height = height, units = 'in', res = 300)
    grid::grid.draw(grob)
    
    # Pull the identifier for the second set of paths added to the plot, which
    # is the regional paths (2nd geom_sf added above)
    grid_list <- grid.ls()
    region_group <- grid_list$name[grep('GRID.pathgrob', grid_list$name)][2]
    
    # grid.garnish needs a handle - determine by running grid.ls() and checking
    # names under panel
    # CRITICAL that row order of referenced dataframe MATCHES plotting order
    gridSVG::grid.garnish(region_group,
                          'class' = rep('CASC_region', nrow(region_sf)),
                          'id' = gsub(' ', '-', region_sf$CASC),
                          group = FALSE, grep = TRUE, redraw = TRUE, global = FALSE)
    
    gridSVG::grid.export(file_out, strict = FALSE)
    dev.off(which=dev.cur())
  } else {
    stop('svg export only set up for when `regions` set to TRUE and `station`
         and `focal_stations` set to FALSE')
  }
  
  return(file_out)
}


