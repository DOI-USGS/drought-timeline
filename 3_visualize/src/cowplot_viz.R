casc_viz_instagram <- function(file_out, drought_data, major_drought_periods,
                               timeline_start, timeline_end, 
                               supporting_font, color_scheme){
  
  # other colors
  background_color = "white"
  hbreaks <- BAMMtools::getJenksBreaks(drought_data$duration, k=10)
  scaledBreaks <- scales::rescale(c(0,hbreaks), c(0,1))
  
  # Load in USGS logo (also a black logo available)
  usgs_logo <- magick::image_read("src/assets/usgsHeaderAndFooter/images/usgsLogo.png") 
  
  # Major Drought Start dates for annotations
  major_drought_annotations <- major_drought_periods |> 
    group_by(name) |>
    summarise(start_date = min(start))
  
  # plot swarm vertically
  p <- drought_data %>% 
    ggplot()+
      # drought events shaded
      geom_ribbon(data = major_drought_periods,
                  aes(ymin = start, ymax = end, x = xfill - 2,
                      group = name),
                  fill = color_scheme$drought_period_shading, alpha = 0.7) +
    geom_tile(aes(y = (date + (duration/2)), x = rnum, 
                  fill = duration, height = duration), width = 0.5)+ # tiles plot centered, so offset x by 1/2 of duration
    scale_fill_scico(values = scaledBreaks, palette = "lajolla", begin = 0.25, end = 1 , 
                     direction = 1,
                     breaks = c(5, 100, 200, 300))+
    theme_nothing() +
      scale_y_date(breaks = scales::date_breaks(width = '5 years'),
                   labels = scales::date_format('%Y'),
                   limits = c(as.Date(timeline_start),
                              as.Date(timeline_end)),
                   expand = c(0,0),
                   position = 'right')
    
  
  # # To check line-up of scales on website, uncomment out lines 17-19, comment
  #   # out line 21, and uncomment out line 22
  #   #theme(axis.text.x = element_blank(),
  #   #      axis.text.y = element_text(size = 14, color = 'blue', angle = 180),
  #   #      panel.grid.major.y = element_line(color = 'blue', linetype = "dashed")) +
  #   scale_y_date(breaks = scales::date_breaks(width = '1 years'),
  #                labels = NULL,
  #                #labels = scales::date_format('%Y'), # use to check line-up on website
  #                limits = c(as.Date(min(drought_data$date)), as.Date(max(drought_data$date + drought_data$duration))),
  #                expand = c(0,0),
  #                position = 'right')
  
  
  
  # # plot violin vertically
  # main_plot <- 
  #   major_drought_periods |> 
  #   ggplot(aes(y = start)) +
  #   # drought events shaded
  #   geom_ribbon(aes(ymin = start, ymax = end, x = xfill - 2,
  #                   group = name),
  #               fill = color_scheme$drought_period_shading, alpha = 0.7) +
  #   # Manually add major drought labels
  #   annotate(geom = "text",
  #            label = major_drought_annotations$name,
  #            x = rep(0.75, length(major_drought_annotations$name)),
  #            y = major_drought_annotations$start_date,
  #            size = 2.5, hjust = 0, vjust = 0,
  #            family = supporting_font,
  #            angle = 180) +
  #   ggdist::geom_dots(data = drought_data, 
  #                     aes(y = date, color = severity), 
  #                     side = "both",
  #                     layout = "weave")+
  #   theme_nothing() + 
  #   theme(axis.text.x = element_blank(),
  #         axis.text.y = element_text(size = 6, 
  #                                    color = color_scheme$annotation_grey, 
  #                                    angle = 180,
  #                                    family = supporting_font),
  #         panel.grid.major.y = element_line(color = color_scheme$annotation_grey, 
  #                                           linewidth = 0.2),
  #         plot.title = element_text(size = 8, color = color_scheme$annotation_grey, 
  #                                   angle = 180, family = supporting_font),
  #         plot.margin = margin(t = 0, r = 0, b = 3, l = 0, unit = "pt")) +
  #   scale_y_date(breaks = scales::date_breaks(width = '5 years'),
  #                labels = scales::date_format('%Y'), 
  #                limits = c(as.Date(timeline_start), 
  #                           as.Date(timeline_end)),
  #                expand = c(0,0),
  #                position = 'right')+
  #     scale_color_scico(palette = "lajolla", begin = 0.25, end = 1 , 
  #                      direction = 1,
  #                      breaks = c(5, 100, 200, 300))
  
  
  canvas <- grid::rectGrob(
    x = 0, y = 0, 
    width = 9, height = 9,
    gp = grid::gpar(fill = background_color, alpha = 1, col = background_color)
  )
  
  ggdraw(ylim = c(0,1), # 0-1 scale makes it easy to place viz items on canvas
         xlim = c(0,1)) +
    # a background
    draw_grob(canvas,
              x = 0, y = 1,
              height = 9, width = 9,
              hjust = 0, vjust = 1) +
    # the main plot
    draw_plot(p,
              x = 0.5,
              y = 0.01,
              height = 1,
              width = 0.25) +
    # explainer text
    draw_label("Snow Cover Index for 2020.\nData from: doi.org/10.5066/P9U7U5FP",
               fontfamily = supporting_font,
               x = 0.96,   
               y = 0.05,
               size = 14,
               hjust = 1,
               vjust = 0,
               color = "cyan")+
    # Add logo
    draw_image(usgs_logo, 
               x = 0.04,
               y = 0.05,
               width = 0.1, 
               hjust = 0, vjust = 0, 
               halign = 0, valign = 0)

  
  ggsave(file_out,
         width = 9, height = 9, dpi = 300, limitsize = FALSE)
  return(file_out)
}
