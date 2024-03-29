plot_radial_chart <- function(major_drought_periods, drought_events, 
                              CASC_angles, supporting_font, color_scheme, 
                              file_out){

  # Join angles data to drought events
  drought_events <- left_join(drought_events, CASC_angles, by = 'CASC')
  
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
          panel.grid.minor = element_blank(),
          # drop extra major grid line that coord_polar adds
          panel.grid.major.y = element_line(color = c(rep('grey85', 13), 'NA')),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")) #+
    # Drop year labels for now, since adding to svg wedges
    # # Manually add year labels
    # annotate(geom = "text",
    #          label = seq(1920, 2020, by = 20), 
    #          x = rep(0, 6), #11
    #          y = as.Date(sprintf("%s-01-01", seq(1920, 2020, by = 20))),
    #          size = 3,
    #          family = supporting_font,
    #          fontface = 2,
    #          color = 'grey10')
  
  ggsave(file_out,
         width = 5, height = 5, dpi = 300, limitsize = FALSE)
  
  return(file_out)
}

plot_radial_wedges <- function(CASC_angles, supporting_font, file_out) {
  # define start and end dates for wedges and y axis
  start_date <- as.Date('1900-01-01')
  end_date <- as.Date('2020-12-31')
  
  # define vector of years for labeling
  label_years <- seq(1920, 2020, by = 20)
  
  wedge_df <- CASC_angles %>%
    arrange(CASC_angle) %>%
    mutate(angle_interval = CASC_angle - lag(CASC_angle))

  # Pull out starting angle and angle interval, for computing offset for coord_polar()
  starting_angle <- min(wedge_df$CASC_angle)
  angle_interval <- mean(wedge_df$angle_interval, na.rm = TRUE)
  
  # drop angle_interval field before plotting, since NA for first element
  wedge_df <- select(wedge_df, -angle_interval)
  
  # Build wedges svg, styling to match radial chart
  wedge_plot <- ggplot(data = wedge_df, 
                       aes(xmin = CASC_angle - angle_interval*0.5, 
                           xmax = CASC_angle + angle_interval*0.5, 
                           ymin = start_date, ymax = end_date)) +
    geom_rect(color = 'black', fill = 'white', alpha = 0) + 
    scale_y_date(breaks = scales::date_breaks(width = '10 years'),
                 labels = scales::date_format('%Y'),
                 # limits are set so that there's blank space in center before timeline starts
                 limits = c(start_date, end_date),
                 expand = c(0,0)) +
    scale_x_continuous(limits = c(0, 371)) +
    coord_polar(start = (starting_angle - (angle_interval / 2)) * (pi/180)) + # start = value from 12 o'clock in radians
    # Match styling of radial chart
    theme_minimal() +
    theme(legend.position = "none",
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")) +
    # Manually add year labels
    annotate(geom = "text",
             label = label_years,
             x = rep(0, 6), #11
             y = as.Date(sprintf("%s-01-01", label_years)),
             size = 3,
             family = supporting_font,
             fontface = 2,
             color = 'grey10')
  
  # gridSVG approach modified from 
  # https://gist.github.com/jimjam-slam/1d988451ae15882c889f49cf20b99a64
  wedge_grob <- wedge_plot %>% ggplotGrob() %>% grid::grid.force()
  dev.new(width = 5, height = 5, units = 'in', res = 300)
  showtext_begin()
  grid::grid.draw(wedge_grob)
  
  # grid.garnish needs a handle - determine by running grid.ls() and checking
  # names under panel
  # CRITICAL that row order of referenced dataframe MATCHES plotting order
  # Assign 'wrapper' id to first child of layout - the panel that holds the plot
  # elements
  gridSVG::grid.garnish('panel',
                        'id' = 'wrapper',
                        group = TRUE, grep = TRUE, redraw = TRUE, global = FALSE)
  # Assign ids and classes to each child within 'geom_rect' - the wedges
  gridSVG::grid.garnish('geom_rect',
               'class' = rep('wedge', nrow(wedge_df)),
               'id' = gsub(' ', '-', wedge_df$CASC),
               group = FALSE, grep = TRUE, redraw = TRUE, global = FALSE)
  # Assign class to each child within 'GRID.text' - the groups containing the
  # axis labels
  gridSVG::grid.garnish('GRID.text',
                        'class' = rep('polarAxisText', length(label_years)),
                        group = FALSE, grep = TRUE, redraw = TRUE, global = FALSE)
  
  gridSVG::grid.export(file_out, strict = FALSE)
  showtext_end()
  dev.off(which=dev.cur())
  
  return(file_out)
}
