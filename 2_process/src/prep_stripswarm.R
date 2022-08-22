create_event_swarm <- function(event_data, start_period, end_period){
  event_subset <- event_data %>% 
    filter(start > start_period) %>%
    filter(start <= end_period) %>% 
    mutate(onset_day = as.integer(start - start_period)) %>% 
    mutate(end_day = as.integer(end - start_period)) %>% 
    arrange(onset_day)
  
  # set up an empty "swarm grid" to place drought events into
  n <- 600 # set arbitrarily large number of possible simultaneous drought events positions. Trimmed prior to plotting
  
  E <- as_tibble(matrix(NaN,nrow=n,ncol=max(event_subset$end_day)+1))
  E <- E %>% mutate(priority = 1:n)
  E <- E %>% arrange(desc(priority)) %>% 
    bind_rows(E) %>% 
    mutate(rnum = 1:(2*n))
  
  # loop through each event and place into best available spot in grid
  progress_bar <- txtProgressBar(min = 1, max = nrow(event_subset), style = 3)
  
  for (idx in 1:nrow(event_subset)){
    temp_dur <- event_subset[[idx,'duration']]
    temp_startd <-event_subset[[idx,'onset_day']]
    # find available spots looking within 1 day +/- the start date (to encourage a little compactness)
    avail_rows <- E %>% select(all_of(temp_startd:(temp_startd + temp_dur - 1)),priority,rnum) %>% 
      filter(is.na(if_all(starts_with("V")))) %>% 
      mutate(pos = 0)
    avail_rows_plus1d <- E %>% select(all_of((temp_startd+1):(temp_startd + temp_dur)),priority,rnum) %>%
      filter(is.na(if_all(starts_with("V")))) %>%
      mutate(pos = 1)
    avail_rows_minus1d <- E %>% select(all_of((temp_startd-1):(temp_startd + temp_dur - 2)),priority,rnum) %>%
      filter(is.na(if_all(starts_with("V")))) %>%
      mutate(pos = -1)
    # find spot closest to central axis
    all_avail_rows <- bind_rows(avail_rows, avail_rows_minus1d, avail_rows_plus1d) %>% 
      arrange(priority) %>%
      group_by(priority) %>%
      slice_sample(prop = 1) %>% # adds a little randomness by assigning to spot above or below central axis randomly
      ungroup()
    temp_rnum <- all_avail_rows[[1,'rnum']]
    temp_pos_key <- all_avail_rows[[1, 'pos']]
    if (temp_startd == 1){
      temp_pos_key <- 0
    }
    # assign event to identified spot by using duration value
    E[temp_rnum,((temp_startd + temp_pos_key):(temp_startd + temp_dur - 1 + temp_pos_key))] <- event_subset[[idx,'duration']]
    E[temp_rnum,(temp_startd + temp_dur + temp_pos_key)] <- 0 # enforces a space between subsequent events
    
    setTxtProgressBar(progress_bar, idx)
  }
  # trim unused rows
  ind <- E %>% select(-priority,-rnum) %>% 
    apply( 1, function(x) all(is.na(x)))
  E <-E[ !ind, ]
  
  E[E == 0] = NaN # remove spaces added to avoid events appearing connected
  
  ncols = ncol(E)-2
  
  E <- mutate(E, decade = as.factor(floor(year(start_period)/10)*10))
  
  plot_dat <- E %>% select(-priority) %>% 
    pivot_longer(cols=1:ncols, names_to = "names", values_to = "duration")
  plot_dat$names<- str_remove(plot_dat$names,"V")
  plot_dat <- plot_dat %>% mutate(dt = as.integer(names)) %>% 
    mutate(date = as.Date(start_period + dt - 1)) %>% 
    mutate(rnum = rnum - n) %>% 
    drop_na()
  
  return(plot_dat)
}

count_events <- function(event_data, metadata, target_threshold){
  event_counts_per_decade <- event_data %>% 
    left_join(metadata, by = "StaID", suffix = c("",".gages")) %>% 
    filter(HUC02 == 14) %>% # restrict to upper Colorado river basin
    filter(threshold == target_threshold) %>% 
    mutate(decade = as.factor(floor(year(start)/10)*10)) %>% 
    group_by(decade) %>% 
    summarize(num_events = n())
  
  return(event_counts_per_decade)
    
}

longest_events <- function(event_data, metadata, target_threshold){
  longest_event_per_decade <- event_data %>% 
    left_join(metadata, by = "StaID", suffix = c("",".gages")) %>% 
    filter(HUC02 == 14) %>% # restrict to upper Colorado river basin
    filter(threshold == target_threshold) %>% 
    mutate(decade = as.factor(floor(year(start)/10)*10)) %>% 
    group_by(decade) %>% 
    slice_max(duration, n = 1)
  
  return(longest_event_per_decade)
  
}

#' @title Expand drought properties
#' @description Expand the drought properties dataframe
#' such that each row (1 drought event) is repeated
#' X times, where X = the duration of the drought event. 
#' Add a new column for date, such that each day within each
#' drought event is represented by a row
#' @param drought_prop the drought properties dataframe
#' to be expanded
#' @return The expanded dataframe, with one row for every
#' day with drought
expand_drought_prop <- function(drought_prop) {
  drought_prop %>% 
    uncount(duration, .remove=FALSE, .id="id") %>%
    mutate(date = start+id-1, .after=end)
}  

#' @title Identify temporal chunks within drought data
#' @description Identify start and end dates by which the drought data
#' can be chunked, such that the breaks between chunks fall on days
#' when there are no droughts at any site
#' @param drought_prop the drought properties dataframe
#' @param min_chunk_days the minimum length (in days) of each chunk
#' that is included in the final set
#' @return a tibble with columns for `chunk_num` (in sequence), the
#' start date for the chunk `start_date`, the end date for each chunk
#' `break_date`, the  length of the chunk, in days `chunk_length_days`,
#' the length of the chunk in years `chunk_length_years`, the maximum
#' number of droughts on any single day within the chunk `max_single_day_droughts`,
#' the total number of drought days (unique site days with drought) `total_drought_days`,
#' and the unique number of days with droughts within each chunk `n_days_w_droughts`
identify_drought_chunks <- function(drought_prop, min_chunk_days) {
  # expand drought properties
  drought_prop_expanded <- expand_drought_prop(drought_prop)
  
  # pull unique drought dates and get count of droughts for each date
  drought_dates <- drought_prop_expanded %>%
    count(date, name='n_droughts')
  
  # get full sequence of dates
  full_date_sequence <- seq.Date(from=min(drought_dates$date),to=max(drought_dates$date),by=1)
  
  # find dates that didn't have droughts
  dates_w_o_drought <- full_date_sequence[!(full_date_sequence %in% drought_dates$date)]
  
  # identify chunks if used all dates w/o drought as breaks
  date_chunks <- tibble(break_date = c(dates_w_o_drought, max(full_date_sequence))) %>%
    mutate(chunk_num = row_number(),
           start_date = case_when(
             chunk_num==1 ~ min(full_date_sequence),
             TRUE ~ lag(break_date)+1),
           chunk_length_days = as.numeric(break_date-start_date))
  # subset to larger chunks only
  selected_chunks <- date_chunks %>%
    filter(chunk_length_days>=min_chunk_days | break_date==max(full_date_sequence)) %>%
    select(break_date) %>%
    # recalculate break_num, start date, and break length
    mutate(chunk_num = row_number(),
           start_date = case_when(
             chunk_num==1 ~ min(full_date_sequence),
             TRUE ~ lag(break_date)+1
           ),
           chunk_length_days = as.numeric(break_date-start_date),
           chunk_length_year = chunk_length_days/365) %>%
    select(chunk_num, start_date, break_date, chunk_length_days, chunk_length_year) %>%
    # figure out the max # of droughts on a single day within each chunk
    group_by(chunk_num) %>%
    group_modify( ~ {
      drought_dates_subset <- drought_dates %>%
        filter(date >= .x$start_date, date<=.x$break_date)
      .x <- mutate(.x, 
                   max_single_day_droughts = max(drought_dates_subset$n_droughts),
                   total_drought_days = sum(drought_dates_subset$n_droughts),
                   n_days_w_droughts = nrow(drought_dates_subset))
    })
