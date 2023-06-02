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
    #       axis.text.y = element_text(size = 14, color = 'blue', angle = 180),
    #       panel.grid.major.y = element_line(color = 'blue', linetype = "dashed")) +
    scale_y_date(breaks = scales::date_breaks(width = '1 years'),
                 labels = NULL,
                 #labels = scales::date_format('%Y'), # use to check line-up on website
                 limits = c(as.Date(min(swarm_data$date)), as.Date(max(swarm_data$date + swarm_data$duration))),
                 expand = c(0,0),
                 position = 'right')
  
}


#' @param chart_type Whether to include years as labels or not 
event_violin_vertical <- function(drought_data){
  # focal CASC
  focal_CASC <- unique(drought_data$CASC)
  
  # plot violin vertically
  plot_out <- drought_data |> 
    ggplot(aes(y = date, x = CASC)) +
    ggdist::geom_dots(color = "#cc5500",
                      fill = NA, side = "both") +
    theme_nothing() + 
      theme(axis.text.x = element_blank(),
            axis.text.y = element_text(size = 6, color = '#dddddd', angle = 180),
            panel.grid.major.y = element_line(color = '#dddddd', linetype = "dashed"),
            plot.title = element_text(size = 8, color = "#333333", 
                                      angle = 180)) +
      scale_y_date(breaks = scales::date_breaks(width = '5 years'),
                   labels = scales::date_format('%Y'), 
                   limits = c(as.Date("1920-01-01"), 
                              as.Date("2020-12-31")),
                   expand = c(0,0),
                   position = 'right')+
      ggtitle(focal_CASC)

  
  ggsave(sprintf("src/assets/images/duration-chart/vertical_violin_jd7d_2pct_%s.png", focal_CASC),
         width = 1.5, height = 5, dpi = 300, limitsize = FALSE)
  
}


event_barcode_plot <- function(drought_data){
  # focal CASC
  focal_CASC <- unique(drought_data$CASC)
  
  # plot violin vertically
  plot_out <- drought_data |> 
    ggplot(aes(y = start, x = CASC)) +
    geom_linerange(aes(ymin = start, ymax = end), 
                   alpha = 0.25, linewidth = 10,
                   color = "#cc5500") +
    theme_nothing()
  
  ggsave(sprintf("src/assets/images/duration-chart/barcode_jd7d_2pct_%s.png", focal_CASC),
         width = 1.5, height = 5, dpi = 300, limitsize = FALSE)
  
}


