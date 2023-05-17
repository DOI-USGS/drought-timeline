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
    # To check line-up of scales on website, uncomment out lines 17-19, comment
    # out line 21, and uncomment out line 22
    # theme(axis.text.x = element_blank(),
    #       axis.text.y = element_text(size = 14, color = 'blue'),
    #       panel.grid.major.y = element_line(color = 'blue', linetype = "dashed")) +
    scale_y_date(breaks = scales::date_breaks(width = '1 years'),
                 labels = NULL,
                 # labels = scales::date_format('%Y'), # use to check line-up on website
                 limits = c(as.Date(min(swarm_data$date)), as.Date(max(swarm_data$date))),
                 expand = c(0,0),
                 position = 'right')
  
}