
plot_inset <- function(station_data, station, us_data, regions, region_sf, focal_stations, focal_station_data, file_out, width, height, color_scheme){
  
  p <- ggplot() + 
    geom_sf(data = us_data,
            fill = "white",
            color = color_scheme$annotation_grey,
            linewidth = 1.2) +
    theme_void() 
    
    if (regions)
      p <- p + geom_sf(data = region_sf,
                       color = NA,
                       alpha = 0.5,
                       fill = color_scheme$drought_event_highlight,
                       linewidth = 2.5)
    
  
    if (station)
      p <- p + geom_sf(data = station_data, shape = 21, 
                       color = "white", fill = "white", 
                       size = 2.2) + 
        geom_sf(data = station_data, shape = 21, 
                color = color_scheme$annotation_grey, 
                fill = color_scheme$annotation_grey, 
                size = 1.4)
    
    if (focal_stations)
      p <- p + geom_sf(data = focal_station_data, shape = 21, 
                       color = color_scheme$drought_event_dark, 
                       fill = color_scheme$drought_event_dark, 
                       size = 2.1)
  
  ggsave(file_out, width = width, height = height, dpi = 300, bg = "transparent", limitsize = FALSE)
  return(file_out)
}


