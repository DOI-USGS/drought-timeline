source('2_process/src/prep_stripswarm.R')

p2_targets <- list(
  ##### General metadata #####
  tar_target(p2_metadata,
             readr::read_csv(p1_metadata_csv, col_types=cols())),
  
  # Define states that are in each CASC region
  tar_target(p2_CASCs, 
             data.frame(
               STATE = state.abb, NAME = state.name
             ) |>
               # remove Alaska, Hawaii
               filter(! STATE %in% c("AK", "HI")) |>
               # define CASCs
               mutate("CASC" = case_when(NAME %in% c("Minnesota", "Iowa", "Missouri", 
                                                     "Wisconsin", "Illinois", "Indiana", 
                                                     "Michigan", "Ohio") ~ "Midwest",
                                         NAME %in% c("Montana", "Wyoming", "Colorado", "North Dakota", 
                                                     "South Dakota", "Nebraska", "Kansas") ~ "North Central",
                                         NAME %in% c("Maine", "New Hampshire", "Vermont", "Massachusetts", 
                                                     "Connecticut", "Rhode Island",
                                                     "New York", "New Jersey", "Pennsylvania", 
                                                     "Delaware", "Maryland", "West Virginia", 
                                                     "Virginia", "Kentucky", "District of Columbia") ~ "Northeast",
                                         NAME %in% c("Washington", "Oregon", "Idaho") ~ "Northwest",
                                         NAME %in% c("New Mexico", "Texas", 
                                                     "Oklahoma", "Louisiana") ~ "South Central",
                                         NAME %in% c("North Carolina", "South Carolina", "Georgia", "Alabama", 
                                                     "Mississippi", "Florida", "Tennessee", 
                                                     "Arkansas") ~ "Southeast",
                                         NAME %in% c("Arizona", "California", 
                                                     "Utah", "Nevada") ~ "Southwest",
                                         TRUE ~ "not sorted")) 
             ),
  
  ##### Data for 1951-2020 #####
  
  ###### Load drought properties ######
  ## Using only variable 7d drought properties
  tar_target(p2_1921_2020_drought_prop_jd_7d,
             readr::read_csv(p1_1921_2020_drought_prop_jd_7d_csv, col_types = cols()) %>%
               mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d'))) |>
               left_join(p2_metadata, by = "StaID")),
  tar_target(p2_1951_2020_drought_prop_jd_7d,
             readr::read_csv(p1_1951_2020_drought_prop_jd_7d_csv, col_types = cols()) %>%
               mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d'))) |>
               left_join(p2_metadata, by = "StaID")),
  tar_target(p2_1981_2020_drought_prop_jd_7d,
             readr::read_csv(p1_1981_2020_drought_prop_jd_7d_csv, col_types = cols()) %>%
               mutate(across(c(start, end), ~as.Date(.x, '%Y-%m-%d'))) |>
               left_join(p2_metadata, by = "StaID")),
  
  ### Prep drought properties for "strip swarm" duration chart
  # Filter to droughts defined using the 2% threshold
  tar_target(p2_all_2pct_droughts,
             join_full_drought_record(df_1921 = p2_1921_2020_drought_prop_jd_7d,
                                      df_1951 = p2_1951_2020_drought_prop_jd_7d,
                                      df_1981 = p2_1981_2020_drought_prop_jd_7d)
             ),
  
  # determine the 2000 most severe droughts
  tar_target(p2_2000_severe_2pct_droughts,
             p2_all_2pct_droughts |>
               slice_max(order_by = severity,
                         n = 2000)
             ),

  # Identify drought chunks
  tar_target(p2_drought_chunks,
             identify_drought_chunks(p2_2000_severe_2pct_droughts, 
                                     min_chunk_days = 365)),
  
  # Process data to generate swarm
  ## 'Compressed' approach (# cells filled per event = 1)
  ## nrow = # of drought events 
  tar_target(p2_drought_swarm_compressed,
             create_event_swarm_compressed(event_data = p2_2000_severe_2pct_droughts,
                                start_period = p2_drought_chunks$start_date,
                                end_period = p2_drought_chunks$break_date,
                                max_droughts = p2_drought_chunks$max_single_day_droughts),
             pattern = map(p2_drought_chunks)),
  
  # Process data for each CASC
  ## Group by CASC, calculate chunks, and then use pattern to create swarm data by chunk and CASC
  tar_target(p2_2000_severe_2pct_droughts_byCASC,
             p2_2000_severe_2pct_droughts |>
               left_join(p2_CASCs, by = "STATE") |> 
               group_by(CASC) |>
               tar_group(),
             iteration = "group"),
  tar_target(p2_drought_chunks_byCASC,
             identify_drought_chunks(p2_2000_severe_2pct_droughts_byCASC, 
                                     min_chunk_days = 365),
             pattern = map(p2_2000_severe_2pct_droughts_byCASC)),
  tar_target(p2_drought_swarm_CASC,
             create_event_swarm_compressed(event_data = p2_2000_severe_2pct_droughts_byCASC,
                                           start_period = p2_drought_chunks_byCASC$start_date,
                                           end_period = p2_drought_chunks_byCASC$break_date,
                                           max_droughts = p2_drought_chunks_byCASC$max_single_day_droughts),
             pattern = cross(p2_2000_severe_2pct_droughts_byCASC, p2_drought_chunks_byCASC))
)
