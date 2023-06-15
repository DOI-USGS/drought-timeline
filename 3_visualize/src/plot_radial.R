plot_radial_chart <- function(major_drought_periods, drought_events, 
                              casc_angles, color_scheme, file_out){
  drought_events <- left_join(drought_events, casc_angles, by = 'CASC')
  
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
                 labels = scales::date_format('%Y'), 
                 # limits are set so that there's blank space in center before timeline starts
                 limits = c(as.Date("1900-01-01"), 
                            as.Date("2020-12-31")),
                 expand = c(0,0)) +
    scale_x_continuous(limits = c(0, 371)) +
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
             size = 2)
  
  ggsave(file_out,
         width = 5, height = 5, dpi = 300, limitsize = FALSE)
  
  return(file_out)
}

plot_radial_wedges <- function(CASC_data, file_out){
  
  wedge_df <- data.frame(
    group = factor(x = unique(CASC_data$CASC),
                   # these levels mean that the CASCs line up with violins
                   levels = c("Southwest",
                              "Northwest", "North Central", 
                              "Midwest", "Northeast",
                              "Southeast", "South Central")),
    # Max year as "y" for the wedges
    ymax = rep(2020, length(unique(CASC_data$CASC)))
  ) %>%
    arrange(group) %>% # svg order = group levels = plotting order
    mutate(CASC_name = as.character(group))
  
  wedge_plot <- ggplot(data = wedge_df, 
         aes(x = group, y = ymax)) +
    geom_bar(width = 0.9, stat = "identity", aes(color = group), fill = 'white', alpha = 0) + 
    coord_polar(start = 10) +
    theme_void() +
    theme(legend.position = "none")
   
  # gridSVG approach modified from 
  # https://gist.github.com/jimjam-slam/1d988451ae15882c889f49cf20b99a64
  wedge_grob <- wedge_plot %>% ggplotGrob() %>% grid::grid.force()
  dev.new(width = 5, height = 5, units = 'in', res = 300)
  grid::grid.draw(wedge_grob)
  
  # grid.garnish needs a handle - determine by running grid.ls() and checking
  # names under panel
  # CRITICAL that row order of referenced dataframe MATCHES plotting order
  gridSVG::grid.garnish('geom_rect',
               'class' = rep('wedge', nrow(wedge_df)),
               'id' = gsub(' ', '-', wedge_df$CASC_name),
               group = FALSE, grep = TRUE, redraw = TRUE, global = FALSE)
  
  gridSVG::grid.export(file_out, strict = FALSE)
  dev.off(which=dev.cur())
  
  return(file_out)
}
