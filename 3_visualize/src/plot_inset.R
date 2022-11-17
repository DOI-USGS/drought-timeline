
plot_inset <- function(station_data, station, western_us_data, us_data, file_png, width, height ){
  
  p <- ggplot() + 
    geom_sf(data = us_data,
            fill = "white",
            color = '#7A7A7A') +
    geom_sf(data = western_us_data,
            fill = '#949494',
            color = '#7A7A7A',
            alpha = 0.5) +
    theme_void() 
    
    
  
    if (station)
      p <- p + geom_sf(data = station_data, shape = 21, color = "white", fill = "black", size = 2)
  
  ggsave(file_png, width = width, height = height, dpi = 300, bg = "transparent", limitsize = FALSE)
  return(file_png)
}


