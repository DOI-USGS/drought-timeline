source('3_visualize/src/plot_stripswarm.R')

p3_targets <- list(
  # Create horizontal duration chart based on Shamshaw's CC 
  tar_target(
    p3_swarm_1980_2020,
    event_swarm_plot(swarm_data = bind_rows(p2_site_swarm, p2_site_swarm_80s, p2_site_swarm_50s))
  ),
  tar_target(p3_swarm_national_png,
             ggsave('src/assets/images/duration-chart/swarm_national.png', 
                    p3_swarm_1980_2020,
                    width = 100, height = 10, dpi = 300, limitsize = FALSE),
             format = "file" )
)

