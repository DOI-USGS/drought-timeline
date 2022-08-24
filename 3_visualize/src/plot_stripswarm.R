
event_swarm_plot <- function(swarm_data){
  
  max_dur <- max(swarm_data$duration)
  max_rnum <- max(swarm_data$rnum)
  
  hbreaks <- BAMMtools::getJenksBreaks(swarm_data$duration, k=10)
  scaledBreaks <- scales::rescale(c(0,hbreaks), c(0,1))
  
  # add font
  font_fam <- 'Noto Sans Display'
  font_add_google(font_fam, regular.wt = 300, bold.wt = 700) 
  showtext_opts(dpi = 300)
  showtext_auto(enable = TRUE)
  
  p <- swarm_data %>% 
    ggplot()+
    #geom_hline(yintercept=0, color="#dddddd",size = 1)+
    geom_tile(aes(x=date, y=rnum, fill = duration), height=0.5)+
    scale_fill_scico(values = scaledBreaks, palette = "lajolla", begin = 0.25, end = 1 , direction = 1,
                     guide_legend(title = "Drought Duration (Days)"), breaks = c(5, 100, 200, 300))+
    theme_minimal()+
    ylab(element_blank())+
    xlab(element_blank())+
    scale_x_date(breaks = scales::date_breaks(width = '1 years'),
                 labels = scales::label_date_short(),
                 expand = c(0,0)) +
    theme(axis.text.y=element_blank(),
          axis.text.x=element_text(size = 14, family = font_fam, hjust = 0),
          panel.grid = element_blank(),
          axis.line.x = element_line(color = "black"),
          legend.position = 'none')
  
}

event_swarm_plot_compressed <- function(swarm_data){
  
  max_dur <- max(swarm_data$duration)
  max_rnum <- max(swarm_data$rnum)
  
  hbreaks <- BAMMtools::getJenksBreaks(swarm_data$duration, k=10)
  scaledBreaks <- scales::rescale(c(0,hbreaks), c(0,1))
  
  # add font
  font_fam <- 'Noto Sans Display'
  font_add_google(font_fam, regular.wt = 300, bold.wt = 700) 
  showtext_opts(dpi = 300)
  showtext_auto(enable = TRUE)
  
  p <- swarm_data %>% 
    ggplot()+
    #geom_hline(yintercept=0, color="#dddddd",size = 1)+
    geom_tile(aes(x=(date+(duration/2)), y=rnum, fill = duration, width=duration), height=0.5)+ # tiles plot centered, so offset x by 1/2 of duration
    scale_fill_scico(values = scaledBreaks, palette = "lajolla", begin = 0.25, end = 1 , direction = 1,
                     guide_legend(title = "Drought Duration (Days)"), breaks = c(5, 100, 200, 300))+
    theme_minimal()+
    ylab(element_blank())+
    xlab(element_blank())+
    scale_x_date(breaks = scales::date_breaks(width = '1 years'),
                 labels = scales::label_date_short(),
                 expand = c(0,0)) +
    theme(axis.text.y=element_blank(),
          axis.text.x=element_text(size = 14, family = font_fam, hjust = 0),
          panel.grid = element_blank(),
          axis.line.x = element_line(color = "black"),
          legend.position = 'none')
  
}

