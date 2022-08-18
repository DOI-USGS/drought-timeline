source('2_process/src/prep_stripswarm.R')

p2_targets <- list(
  ##### General metadata #####
  tar_target(p2_metadata,
             readr::read_csv(p1_metadata_csv, col_types=cols())),

  tar_target(p2_casc_list,
             # Climate Adaptation Regions
             list(NW = c('WA','OR','ID'),
                  SW = c('CA','UT','NV','NM'),
                  NC = c('MT','ND','SD','WY','CO','NE','KS'),
                  MW = c('WI','MN','IA','IN','IL','OH','MI'),
                  NE = c('ME','VT','NH','NY','NJ','MA','RI','CT','WV','VA','MD','DE','KY'),
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
  tar_target(p2_1951_2020_drought_prop_site,
             readr::read_csv(p1_1951_2020_drought_prop_site_csv, col_types = cols()) %>%
              mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d')))),
  tar_target(p2_1951_2020_drought_prop_jd_7d,
             readr::read_csv(p1_1951_2020_drought_prop_jd_7d_csv, col_types = cols()) %>%
               mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d')))),
  
  ## Prep drought properties for "strip swarm" duration chart
  tar_target(p2_site_prop_2,
             # Filter to 2 threshold for now
             p2_1951_2020_drought_prop_site %>%
               filter(threshold == 2) %>%
               left_join(p2_1951_2020_metadata %>%
                           select(StaID:STATE, HCDN_2009, CASC))
  ),
  ## Processing data in 2 temporal chunks, processing swarm is slow (~20 min)
  tar_target(p2_site_swarm,
             create_event_swarm(event_data = p2_site_prop_2,
                                start_period = as.Date('2000-01-01'),
                                end_period = as.Date('2020-12-31'))), 
  tar_target(p2_site_swarm_80s,
             create_event_swarm(event_data = p2_site_prop_2,
                                start_period = as.Date('1980-01-01'),
                                end_period = as.Date('1999-12-31'))),
  tar_target(p2_site_swarm_50s,
             create_event_swarm(event_data = p2_site_prop_2,
                                start_period = as.Date('1950-01-01'),
                                end_period = as.Date('1979-12-31')))
)
