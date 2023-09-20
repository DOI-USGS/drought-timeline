casc_viz_instagram <- function(file_out, 
                               casc_name,
                               swarm_pngs,
                               timeline_start, timeline_end, 
                               supporting_font, color_scheme, fancy_font){
  fancy_font <- "Gochi Hand"
  sysfonts::font_add_google(fancy_font)
  showtext::showtext_opts(dpi = 300, regular.wt = 200, bold.wt = 900)
  showtext::showtext_auto(enable = TRUE)
  
  # other colors
  background_color = "white"
  text_color = "#36453f"
  
  # Load in USGS logo 
  usgs_logo <- magick::image_read("src/assets/usgsHeaderAndFooter/images/usgsLogo.png") 
  
  # Load in drought background 
  background <- magick::image_read("src/assets/images/drought_bkgd.png") 
  
  # Load in drought swarms
  swarm_flipped <- magick::image_read(swarm_pngs) |> 
    magick::image_rotate(180)
  
  # Load in map
  map_image <- magick::image_read(sprintf("src/assets/images/states_regions_%s.png",
                                          gsub(' ', '-', casc_name)))
  
  canvas <- grid::rectGrob(
    x = 0, y = 0, 
    width = 9, height = 9,
    gp = grid::gpar(fill = background_color, alpha = 1, col = background_color)
  )
  
  # vertical spacing
  gap <- 0.079
  
  ggdraw(ylim = c(0,1), # 0-1 scale makes it easy to place viz items on canvas
         xlim = c(0,1)) +
    # a background
    draw_grob(canvas,
              x = 0, y = 1,
              height = 9, width = 9,
              hjust = 0, vjust = 1) +
    draw_image(background,
               x = 0,
               y = 0,
               height = 1)+
    # the main plot
    draw_image(swarm_flipped,
              x = 0.08,
              y = 0.15,
              height = 0.8) +
    draw_image(map_image,
               x = -0.31,
               y = 0.13,
               height = 0.2)+
    # annotations
    draw_label("Each bar is one\nstreamflow drought",
               x = 0.05, y = 0.61,
               fontfamily = fancy_font,
               size = 22,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color) +
    draw_label("Darker bars =\nlonger droughts",
               x = 0.05, 
               y = 0.46,
               fontfamily = fancy_font,
               size = 22,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color) +
    # cowplot::draw_line(x = c(0.2, 0.3), # straight line
    #                    y = c(0.5, 0.6))+
    # cowplot::draw_line(x = c(0.1, 0.2), # arrow head
    #                    y = c(0.1, 0.1))+
    # title
    draw_label("100 years of streamflow\ndrought in the",
               fontfamily = supporting_font,
               x = 0.05,
               y = 0.88,
               size = 30,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label(casc_name,
               fontfamily = fancy_font,
               x = 0.05,
               y = 0.82,
               size = 50,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = color_scheme$drought_event_dark)+
    draw_label("United States",
               fontfamily = supporting_font,
               x = 0.05,
               y = 0.77,
               size = 30,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    # explainer text
    draw_label(sprintf("The 1000 most severe streamflow droughts at USGS\ngages in the %s from 1920-2020. See more at:\nlabs.waterdata.usgs.gov/visualizations/drought-timeline",
                       casc_name),
               fontfamily = supporting_font,
               x = 0.05,   
               y = 0.05,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    # Year labels
    draw_label("1920",
               x = 0.9,
               y = 0.938,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1930",
               x = 0.9,
               y = 0.938-gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1940",
               x = 0.9,
               y = 0.938-2*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1950",
               x = 0.9,
               y = 0.938-3*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1960",
               x = 0.9,
               y = 0.938-4*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1970",
               x = 0.9,
               y = 0.938-5*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1980",
               x = 0.9,
               y = 0.938-6*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("1990",
               x = 0.9,
               y = 0.938-7*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("2000",
               x = 0.9,
               y = 0.938-8*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("2010",
               x = 0.9,
               y = 0.938-9*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    draw_label("2020",
               x = 0.9,
               y = 0.938-10*gap,
               fontfamily = supporting_font,
               size = 17,
               hjust = 0,
               vjust = 0,
               fontface = "bold",
               color = text_color)+
    # Add logo
    draw_image(usgs_logo, 
               x = 0.8,
               y = 0.05,
               width = 0.16, 
               hjust = 0, vjust = 0, 
               halign = 0, valign = 0)

  
  ggsave(file_out,
         width = 9, height = 9, dpi = 300, limitsize = FALSE)
  return(file_out)
}


casc_swarms <- function(file_out, drought_data, major_drought_periods,
                               timeline_start, timeline_end, 
                               supporting_font, color_scheme){
  
  text_color = "#36453f"
  
  # other colors
  background_color = "white"
  hbreaks <- BAMMtools::getJenksBreaks(drought_data$duration, k=10)
  scaledBreaks <- scales::rescale(c(0,hbreaks), c(0,1))
  
  # Major Drought Start dates for annotations
  major_drought_annotations <- major_drought_periods |> 
    group_by(name) |>
    summarise(start_date = min(start))
  
  # plot swarm vertically
  p <- drought_data %>% 
    ggplot()+
    geom_tile(aes(y = (date + (duration/2)), x = rnum, 
                  fill = duration, height = duration), width = 0.5)+ # tiles plot centered, so offset x by 1/2 of duration
    scale_fill_scico(values = scaledBreaks, palette = "lajolla", begin = 0.25, end = 1 , 
                     direction = 1,
                     breaks = c(5, 100, 200, 300))+
    theme_nothing() +
      scale_y_date(breaks = scales::date_breaks(width = '10 years'),
                   labels = scales::date_format('%Y'),
                   limits = c(as.Date(timeline_start),
                              as.Date(timeline_end)),
                   expand = c(0,0),
                   position = 'left')+
      theme(axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            panel.grid.major.y = element_line(color = color_scheme$annotation_grey,
                                              linewidth = 0.2),
            plot.title = element_text(size = 8, color = color_scheme$annotation_grey,
                                      angle = 0, family = supporting_font),
            plot.margin = margin(t = 0, r = 0, b = 3, l = 0, unit = "pt"))

  
  
  
  ggsave(file_out,
         width = 8, height = 10, dpi = 300, limitsize = FALSE)
  return(file_out)
}