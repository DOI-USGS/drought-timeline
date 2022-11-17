
plot_inset <- function(station_data, western_us_data, us_data){
  
  ggplot() + 
    geom_sf(data = us_data,
            fill = NA,
            color = 'black') +
    geom_sf(data = western_us_data,
            fill = '#DDE2E3',
            color = NA,
            alpha = 0.5) +
    #geom_sf(data = station_data) +
    theme_void() 
    # in the chance you prefer a black border around the inset but still want to remove all unncessary theming elements
    # theme(axis.text.y   = element_blank(),
    #       axis.text.x   = element_blank(),
    #       axis.title.y  = element_blank(),
    #       axis.title.x  = element_blank(),
    #       panel.background = element_blank(),
    #       panel.grid.major = element_blank(), 
    #       panel.grid.minor = element_blank(),
    #       axis.line = element_blank(),
    #       axis.ticks.x = element_blank(),
    #       axis.ticks.y = element_blank(),
    #       plot.margin = margin(0, 0, 0, 0, "cm"),
    #       panel.border = element_rect(color = "black", fill=NA, size=0.75))
}


