
plot_inset <- function(station_data, station, us_data, regions, region_sf, file_png, width, height, color_scheme){
  
  p <- ggplot() + 
    geom_sf(data = us_data,
            fill = "white",
            color = color_scheme$annotation_grey,
            linewidth = 1.2) +
    theme_void() 
    
    if (regions)
      p <- p + geom_sf(data = region_sf,
                       color = "#dd8e58",
                       fill = NA,
                       linewidth = 2.5)
    
  
    if (station)
      p <- p + geom_sf(data = station_data, shape = 21, 
                       color = "white", fill = "black", 
                       size = 2)
  
  ggsave(file_png, width = width, height = height, dpi = 300, bg = "transparent", limitsize = FALSE)
  return(file_png)
}


