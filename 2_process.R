source('2_process/src/prep_stripswarm.R')

p2_targets <- list(
  ##### General metadata #####
  tar_target(p2_metadata_raw,
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
                                         TRUE ~ "not sorted"),
                      # these angles are set 51.4 degrees apart starting at Midwest for polar plot
                      "CASC_angle" = case_when(CASC == "Midwest" ~ 41.0,
                                               CASC == "Northeast" ~ 92.4,
                                               CASC == "Southeast" ~ 143.8,
                                               CASC == "South Central" ~ 195.2,
                                               CASC == "Southwest" ~ 246.6,
                                               CASC == "Northwest" ~ 298.0,
                                               CASC == "North Central" ~ 349.4)) 
  ),
  # Attach CASCs to metadata
  tar_target(p2_metadata,
             p2_metadata_raw |> left_join(p2_CASCs, by = "STATE")),
  
  
  
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
  # Join full record and then filter to droughts defined using the target percentile
  tar_target(p2_all_2pct_droughts,
             join_and_filter_full_drought_record(df_1921 = p2_1921_2020_drought_prop_jd_7d,
                                                 df_1951 = p2_1951_2020_drought_prop_jd_7d,
                                                 df_1981 = p2_1981_2020_drought_prop_jd_7d,
                                                 percentile = 2)
  ),
  
  # determine the 2000 most severe droughts
  tar_target(p2_2000_severe_2pct_droughts,
             p2_all_2pct_droughts |>
               slice_max(order_by = severity,
                         n = 2000)
  ),
  
  # Identify drought chunks
  tar_target(p2_drought_chunks,
             identify_drought_chunks(drought_prop = p2_2000_severe_2pct_droughts, 
                                     min_chunk_days = 365)),
  
  # Process data to generate swarm
  ## 'Compressed' approach (# cells filled per event = 1)
  ## nrow = # of drought events = nrow(p2_prop_severe_2pct_droughts)
  tar_target(p2_drought_swarm_compressed,
             create_event_swarm_compressed(event_data = p2_2000_severe_2pct_droughts,
                                           start_period = p2_drought_chunks$start_date,
                                           end_period = p2_drought_chunks$break_date,
                                           max_droughts = p2_drought_chunks$max_single_day_droughts),
             pattern = map(p2_drought_chunks)),
  
  # Expand drought properties of 2000 most severe droughts and group by CASC
  tar_target(p2_2000_severe_2pct_droughts_byCASC,
             p2_2000_severe_2pct_droughts |> 
               group_by(CASC) |>  
               tar_group(),
             iteration = "group"),
  
  tar_target(p2_expanded_2000_2pct_droughts_byCASC,
             expand_drought_prop(drought_prop = p2_2000_severe_2pct_droughts) |> 
               group_by(CASC) |>
               tar_group(),
             iteration = "group"),
  
  ## Define the 5 major drought periods
  tar_target(p2_major_droughts,
             tibble(
               name = c("Dust Bowl", "1950s Drought", "1960s Drought", 
                        "1980s Drought", "Turn-of-the-Century Drought"),
               major_drought_id = c("1930", "1952", "1962", "1987", "1999"),
               start = as.Date(c("1930-02-01", "1952-11-01", "1962-12-01",
                                 "1987-05-01", "1999-09-01")),
               end = as.Date(c("1941-08-31", "1957-08-31", "1968-10-31",
                               "1992-10-31", "2015-09-30"))
             ) |>
               mutate(duration = as.duration(interval(start, end)) / ddays(1))),
  
  ## Expand to determine all days within drought
  tar_target(p2_major_droughts_expanded_by_day,
             expand_drought_prop(drought_prop = p2_major_droughts)),
  
  ## Expand for plotting geom ribbons (shading on regional plots)
  tar_target(p2_major_droughts_expanded,
             data.frame(
               name = rep(p2_major_droughts$name, each = 381),
               start = rep(p2_major_droughts$start, each = 381),
               end = rep(p2_major_droughts$end, each = 381),
               angle = rep(0:380, 5),
               xfill = rep(seq(0, 3.8, by = 0.01), 5)
             )),
  
  ## Collect all droughts that start during the five major droughts for mapping insets
  tar_target(p2_expanded_droughts_during_major_drought_periods,
             expand_drought_prop(p2_2000_severe_2pct_droughts) |>
               # join with major droughts
               left_join(p2_major_droughts_expanded_by_day |>
                           rename(major_start = start, major_end = end, major_duration = duration), 
                         by = "date") |>
               # remove all non-major drought periods
               filter(! is.na(name)) |>
               group_by(name) |>
               tar_group(),
             iteration = "group")
  
)
