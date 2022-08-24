source('2_process/src/prep_stripswarm.R')

p2_targets <- list(
  ##### General metadata #####
  tar_target(p2_metadata,
             readr::read_csv(p1_metadata_csv, col_types=cols())),

  tar_target(p2_casc_list,
             # Climate Adaptation Regions
             list(NW = c('WA','OR','ID'),
                  SW = c('CA','UT','NV','AZ'),
                  SC = c('OK','TX','LA','NM'),
                  NC = c('MT','ND','SD','WY','CO','NE','KS'),
                  MW = c('WI','MN','IA','IN','IL','OH','MI', 'MO'),
                  NE = c('ME','VT','NH','NY','NJ','PA','MA','RI','CT','WV','VA','MD','DE','KY'),
                  SE = c('AR','MS','TN','NC','SC','AL','FL','GA','PR'),
                  PI = c('HI','AS','GU'),
                  AK = c('AK'))
  ),
  
  ##### Data for 1951-2020 #####

  ###### Get 1951-2020 metadata ######
  tar_target(p2_1951_2020_metadata,
             filter(p2_metadata, national_1951)%>%
               mutate(CASC = case_when(
                 STATE %in% p2_casc_list$NW ~ 'NW',
                 STATE %in% p2_casc_list$SW ~ 'SW',
                 STATE %in% p2_casc_list$SC ~ 'SC',
                 STATE %in% p2_casc_list$NC ~ 'NC',
                 STATE %in% p2_casc_list$MW ~ 'MW',
                 STATE %in% p2_casc_list$NE ~ 'NE',
                 STATE %in% p2_casc_list$SE ~ 'SE'
               )) %>%
               filter(!is.na(CASC))),
  
  ###### Load drought properties ######
  tar_target(p2_1951_2020_drought_prop_jd_7d,
             readr::read_csv(p1_1951_2020_drought_prop_jd_7d_csv, col_types = cols()) %>%
               mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d')))),
  
  ### Prep drought properties for "strip swarm" duration chart
  ## All variable 7d
  # National - 2%
  tar_target(p2_nat_2,
             p2_1951_2020_drought_prop_jd_7d %>%
               filter(threshold == 2) %>%
               left_join(p2_1951_2020_metadata %>%
                           select(StaID:STATE, HCDN_2009, CASC))),
  # Identify drought chunks
  tar_target(p2_nat_2_drought_chunks,
             identify_drought_chunks(p2_nat_2, min_chunk_days=365/3)),
  
  ## Process data to generate swarm
  tar_target(p2_nat_2_swarm,
             create_event_swarm(event_data = p2_nat_2,
                                             start_period = p2_nat_2_drought_chunks$start_date,
                                             end_period = p2_nat_2_drought_chunks$break_date,
                                             max_droughts = p2_nat_2_drought_chunks$max_single_day_droughts),
             pattern = map(p2_nat_2_drought_chunks)),
  
  tar_target(p2_nat_2_swarm_compressed,
             create_event_swarm_compressed(event_data = p2_nat_2,
                                start_period = p2_nat_2_drought_chunks$start_date,
                                end_period = p2_nat_2_drought_chunks$break_date,
                                max_droughts = p2_nat_2_drought_chunks$max_single_day_droughts),
             pattern = map(p2_nat_2_drought_chunks))
)
