event_swarm_plot_compressed_vertical <- function(swarm_data){
  
  hbreaks <- BAMMtools::getJenksBreaks(swarm_data$duration, k=10)
  scaledBreaks <- scales::rescale(c(0,hbreaks), c(0,1))

  # plot swarm vertically
  p <- swarm_data %>% 
    ggplot()+
    geom_tile(aes(y = (date + (duration/2)), x = rnum, 
                  fill = duration, height = duration), width = 0.5)+ # tiles plot centered, so offset x by 1/2 of duration
    scale_fill_scico(values = scaledBreaks, palette = "lajolla", begin = 0.25, end = 1 , 
                     direction = 1,
                     breaks = c(5, 100, 200, 300))+
    theme_nothing() +
    #theme_minimal()+ #use to check line-up on website
    scale_y_date(breaks = scales::date_breaks(width = '1 years'),
                 labels = NULL,
                 #labels = scales::date_format('%Y'), #use to check line-up on website
                 limits = c(as.Date("1921-03-15", "%Y-%m-%d"), as.Date("2021-03-31", "%Y-%m-%d")),
                 expand = c(0,0),
                 position = 'right')
  
}