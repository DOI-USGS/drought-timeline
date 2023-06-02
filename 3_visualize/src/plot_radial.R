plot_radial_chart <- function(major_droughts){
  ggplot(data = major_droughts, aes(x = angle, y = start, group = name))+
    geom_ribbon(aes(ymin = start, ymax = end,
                    xmin = angle, xmax = angle),
                fill = "#DAA520", alpha = 0.1)+
    scale_y_date(breaks = scales::date_breaks(width = '10 years'),
                 #labels = NULL,
                 labels = scales::date_format('%Y'), # use to check line-up on website
                 limits = c(as.Date("1900-01-01"), 
                            as.Date("2020-12-01")),
                 expand = c(0,0))+
    coord_polar()+
    theme_minimal() +
    theme(legend.position = "none",
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())
  
  ggsave("src/assets/images/duration-chart/polar_background_plot.png",
         width = 5, height = 5, dpi = 300, limitsize = FALSE)
}