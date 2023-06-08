plot_radial_chart <- function(major_drought_periods, drought_events, color_scheme){
  
  # Using the major droughts, create concentric circles that are grey
  ggplot(data = major_drought_periods, aes(x = angle, y = start))+
    geom_ribbon(aes(ymin = start, ymax = end,
                    xmin = angle, xmax = angle,
                    group = name),
                fill = color_scheme$drought_period_shading, alpha = 0.7) +
    geom_violin(data = drought_events,
                aes(x = CASC_angle, y = date, group = CASC),
                color = NA, 
                fill = color_scheme$drought_event_highlight,
                scale = "count",
                adjust = 0.2) +
    scale_y_date(breaks = scales::date_breaks(width = '10 years'),
                 #labels = NULL,
                 labels = scales::date_format('%Y'), # use to check line-up on website
                 limits = c(as.Date("1900-01-01"), 
                            as.Date("2020-12-31")),
                 expand = c(0,0)) +
    scale_x_continuous(limits = c(0, 373)) +
    coord_polar() +
    theme_minimal() +
    theme(legend.position = "none",
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())+
    # Manually add year labels
    annotate(geom = "text",
             label = seq(1920, 2020, by = 10), 
             x = rep(0, 11),
             y = as.Date(sprintf("%s-01-01", seq(1920, 2020, by = 10))),
             size = 2.5)
  
  ggsave("src/assets/images/duration-chart/polar_background_plot.png",
         width = 5, height = 5, dpi = 300, limitsize = FALSE)
}