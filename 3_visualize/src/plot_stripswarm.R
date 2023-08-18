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



event_violin_vertical <- function(drought_data, major_drought_periods, 
                                  timeline_start, timeline_end,
                                  supporting_font, color_scheme, file_out) {
  
  # focal CASC
  focal_CASC <- unique(drought_data$CASC)
  
  # Major Drought Start dates for annotations
  major_drought_annotations <- major_drought_periods |> 
    group_by(name) |>
    summarise(start_date = min(start))
  
  # plot violin vertically

  major_drought_periods |> 
    ggplot(aes(y = start,
               x = xfill)) +
    # drought events shaded
    geom_ribbon(aes(ymin = start, ymax = end,
                    group = name),
                fill = color_scheme$drought_period_shading, alpha = 0.7) +
    # Manually add major drought labels
    annotate(geom = "text",
             label = major_drought_annotations$name,
             x = rep(2.75, length(major_drought_annotations$name)),
             y = major_drought_annotations$start_date,
             size = 2.5, angle = 180, hjust = 0, vjust = 0,
             family = supporting_font) +
    geom_violin(data = drought_data,
                aes(x = 2, y = date),
                color = NA, 
                fill = color_scheme$drought_event_highlight,
                scale = "count",
                adjust = 0.2) +
    theme_nothing() + 
    theme(axis.text.x = element_blank(),
          axis.text.y = element_text(size = 6, 
                                     color = color_scheme$annotation_grey, 
                                     angle = 180,
                                     family = supporting_font),
          panel.grid.major.y = element_line(color = color_scheme$annotation_grey, 
                                            linewidth = 0.2),
          plot.title = element_text(size = 8, color = color_scheme$annotation_grey, 
                                    angle = 180, family = supporting_font),
          plot.margin = margin(t = 0, r = 0, b = 3, l = 0, unit = "pt")) +
    scale_y_date(breaks = scales::date_breaks(width = '5 years'),
                 labels = scales::date_format('%Y'), 
                 limits = c(as.Date(timeline_start), 
                            as.Date(timeline_end)),
                 expand = c(0,0),
                 position = 'right')+
    # Here this scale gives equidistant spacing on either side of "2" (the threshold)
    scale_x_continuous(limits = c(1.25, 2.75))#+
    #ggtitle(focal_CASC) 

  
  ggsave(file_out,
         width = 1.5, height = 5, dpi = 300, limitsize = FALSE)
  return(file_out)
}




