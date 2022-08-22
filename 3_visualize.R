source('3_visualize/src/plot_stripswarm.R')

p3_targets <- list(
  # National - 2%
  # (takes 2 hours to build...could consider chunking plot, too?)
  tar_target(
    p3_nat_2_swarm_plot,
    event_swarm_plot(swarm_data = p2_nat_2_swarm)
  ),
  tar_target(p3_nat_2_swarm_png,
             ggsave('src/assets/images/duration-chart/swarm_national.png', 
                    p3_nat_2_swarm_plot,
                    width = 100, height = 10, dpi = 300, limitsize = FALSE),
             format = "file" )
)

