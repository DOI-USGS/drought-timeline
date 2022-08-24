#' @title Create strip-swarm matrix from drought events
#' @description Populate an event matrix, where columns = days
#' and rows = drought events. Iterate through the drought events
#' and add them such that each drought event spans X cells, where 
#' X = the duration of the drought event. Place the drought events
#' as close to the vertical center of the matrix as possible.
#' Separate the drought events horizontally by one cell.
#' @param event_data
#' @param start_period the start date of the chunk of events being
#' processed
#' @param end_period the end date of the chunk of events being processed
#' @param max_droughts the maximum number of drought events on a single
#' day within the chunk of events. Used to set the number of rows in
#' the event matrix
#' @return A dataframe with a row for each drought day (unique site day 
#' with drought) and columns for row number `rnum`, `date`, `duration`
create_event_swarm <- function(event_data, start_period, end_period, max_droughts){
  
  event_subset <- event_data %>% 
    filter(start >= start_period) %>%
    filter(start <= end_period) %>% # Ok to filter only `start` b/c `end_period` accounts for duration of latest drought events (set in `identify_drought_chunks()`)
    mutate(onset_day = as.integer(start - start_period) + 1) %>% 
    mutate(end_day = onset_day + duration - 1) %>% # End value in raw data doesn't always = start + duration - 1
    arrange(onset_day) %>%
    mutate(idx = row_number())
  
  # set up an empty "swarm grid" to place drought events into
  n <- round(max_droughts/2)+10 # will be mirrored, so start w/ ~ 1/2 max_droughts + some wiggle room
  mat <- matrix(NaN,nrow=n,ncol=max(event_subset$end_day)+2) # 1 additional for spacer 0 value at end, 1 additional in case last drought placed on plus1d location
  E_1 <- setDT(as.data.frame(mat))[]
  E_1[,priority:=1:n]
  E_2 <- E_1[order(-priority)]
  E <- rbindlist(list(E_2, E_1))
  E[,rnum:=1:(2*n)]
  
  # loop through each event and place into best available spot in grid
  progress_bar <- txtProgressBar(min = 1, max = nrow(event_subset), style = 3)
  
  # store priority, rnum for all rows
  rnum_priority <- E[,.(priority,rnum)]

  for (idx in 1:nrow(event_subset)){
    temp_dur <- event_subset[[idx,'duration']]
    temp_startd <-event_subset[[idx,'onset_day']]
    
    avail_rows_d <- E[,temp_startd:(temp_startd + temp_dur - 1)]
    avail_rows_d <- cbind(avail_rows_d, rnum_priority)
    avail_rows_d <- avail_rows_d[rowSums(is.na(avail_rows_d))==(ncol(avail_rows_d)-2),] # pull rows where all but priority and rnum are NA
    avail_rows_d[,pos:=0]
    avail_rows_plus1d <- E[,(temp_startd+1):(temp_startd + temp_dur)]
    avail_rows_plus1d <- cbind(avail_rows_plus1d, rnum_priority)
    avail_rows_plus1d <- avail_rows_plus1d[rowSums(is.na(avail_rows_plus1d))==(ncol(avail_rows_plus1d)-2),]
    avail_rows_plus1d[,pos:=1]
    avail_rows_minus1d <- E[,(temp_startd-1):(temp_startd + temp_dur - 2)]
    avail_rows_minus1d <- cbind(avail_rows_minus1d, rnum_priority)
    avail_rows_minus1d <- avail_rows_minus1d[rowSums(is.na(avail_rows_minus1d))==(ncol(avail_rows_minus1d)-2),]
    avail_rows_minus1d[,pos:=-1]
    all_avail_rows <- rbindlist(list(avail_rows_d, avail_rows_minus1d, avail_rows_plus1d), fill=TRUE) # need fill+TRUE to not drop columns that aren't shared
    all_avail_rows <- all_avail_rows[priority==min(priority)] # filter to min priority, since want lowest value (highest priority) row(s)
    all_avail_rows <- all_avail_rows[sample(.N,1)] # randomly select one of the highest priority rows
    
    temp_rnum <- all_avail_rows[,rnum]
    temp_pos_key <- all_avail_rows[,pos]
    if (temp_startd == 1){
      temp_pos_key <- 0
    }
    
    # assign event to identified spot by using duration value
    E[temp_rnum,((temp_startd + temp_pos_key):(temp_startd + temp_dur - 1 + temp_pos_key))] <- temp_dur
    E[temp_rnum,(temp_startd + temp_dur + temp_pos_key)] <- 0 # enforces a space between subsequent events
    
    setTxtProgressBar(progress_bar, idx)
  }
  
  # trim unused rows
  E_ind <- rowSums(is.na(E))==(ncol(E)-2) # identify rows where all but priority and rnum are NA
  E <- E[ !E_ind, ]
  
  E[E == 0] <- NaN # remove spaces added to avoid events appearing connected
  
  E <- E[,priority:=NULL] # drop priority column
  plot_dat <- melt(E, measure.vars=colnames(E)[1:(ncol(E)-1)], # all but last column (rnum)
                      variable.name="names",value.name = "duration")
  plot_dat[,dt:=as.integer(str_remove(names,"V"))]
  plot_dat[,date:=as.Date(start_period + dt - 1)]
  plot_dat[,rnum:=rnum - n]
  plot_dat <- na.omit(plot_dat)
  
  # drop names and dt columns
  plot_dat <- plot_dat[,names:=NULL]
  plot_dat <- plot_dat[,dt:=NULL]
  
  plot_dat_df <- as.data.frame(plot_dat)
  
  return(plot_dat_df)
}

#' @title Create strip-swarm matrix from drought events
#' @description Populate an event matrix, where columns = days
#' and rows = drought events. Iterate through the drought events
#' and add them such that each drought event spans X cells, where 
#' X = the duration of the drought event. Place the drought events
#' as close to the vertical center of the matrix as possible.
#' Separate the drought events horizontally by one cell.
#' @param event_data
#' @param start_period the start date of the chunk of events being
#' processed
#' @param end_period the end date of the chunk of events being processed
#' @param max_droughts the maximum number of drought events on a single
#' day within the chunk of events. Used to set the number of rows in
#' the event matrix
#' @return A dataframe with a row for each drought event and columns for 
#' row number `rnum`, `date`, `duration`
create_event_swarm_compressed <- function(event_data, start_period, end_period, max_droughts){
  
  event_subset <- event_data %>% 
    filter(start >= start_period) %>%
    filter(start <= end_period) %>% # Ok to filter only `start` b/c `end_period` accounts for duration of latest drought events (set in `identify_drought_chunks()`)
    mutate(onset_day = as.integer(start - start_period) + 1) %>% 
    mutate(end_day = onset_day + duration - 1) %>% # End value in raw data doesn't always = start + duration - 1
    arrange(onset_day) %>%
    mutate(idx = row_number())
  
  # set up an empty "swarm grid" to place drought events into
  n <- round(max_droughts/2)+10 # will be mirrored, so start w/ ~ 1/2 max_droughts + some wiggle room
  mat <- matrix(NaN,nrow=n,ncol=max(event_subset$end_day)+2) # 1 additional for spacer 0 value at end, 1 additional in case last drought placed on plus1d location
  E_1 <- setDT(as.data.frame(mat))[]
  E_1[,priority:=1:n]
  E_2 <- E_1[order(-priority)]
  E <- rbindlist(list(E_2, E_1))
  E[,rnum:=1:(2*n)]
  
  # loop through each event and place into best available spot in grid
  # set up progress bar when multiple events to process
  if (nrow(event_subset) > 1) {
    progress_bar <- txtProgressBar(min = 1, max = nrow(event_subset), style = 3)
  }
  
  # store priority, rnum for all rows
  rnum_priority <- E[,.(priority,rnum)]
  
  for (idx in 1:nrow(event_subset)){
    temp_dur <- event_subset[[idx,'duration']]
    temp_startd <-event_subset[[idx,'onset_day']]
    
    avail_rows_d <- E[,temp_startd:(temp_startd + temp_dur - 1)]
    avail_rows_d <- cbind(avail_rows_d, rnum_priority)
    avail_rows_d <- avail_rows_d[rowSums(is.na(avail_rows_d))==(ncol(avail_rows_d)-2),] # pull rows where all but priority and rnum are NA
    avail_rows_d[,pos:=0]
    avail_rows_plus1d <- E[,(temp_startd+1):(temp_startd + temp_dur)]
    avail_rows_plus1d <- cbind(avail_rows_plus1d, rnum_priority)
    avail_rows_plus1d <- avail_rows_plus1d[rowSums(is.na(avail_rows_plus1d))==(ncol(avail_rows_plus1d)-2),]
    avail_rows_plus1d[,pos:=1]
    avail_rows_minus1d <- E[,(temp_startd-1):(temp_startd + temp_dur - 2)]
    avail_rows_minus1d <- cbind(avail_rows_minus1d, rnum_priority)
    avail_rows_minus1d <- avail_rows_minus1d[rowSums(is.na(avail_rows_minus1d))==(ncol(avail_rows_minus1d)-2),]
    avail_rows_minus1d[,pos:=-1]
    all_avail_rows <- rbindlist(list(avail_rows_d, avail_rows_minus1d, avail_rows_plus1d), fill=TRUE) # need fill+TRUE to not drop columns that aren't shared
    all_avail_rows <- all_avail_rows[priority==min(priority)] # filter to min priority, since want lowest value (highest priority) row(s)
    all_avail_rows <- all_avail_rows[sample(.N,1)] # randomly select one of the highest priority rows
    
    temp_rnum <- all_avail_rows[,rnum]
    temp_pos_key <- all_avail_rows[,pos]
    if (temp_startd == 1){
      temp_pos_key <- 0
    }
    
    # assign event to identified spot by using duration value
    # instead of assigning all cells duration value
    # using E[temp_rnum,((temp_startd + temp_pos_key):(temp_startd + temp_dur - 1 + temp_pos_key))] <- temp_dur
    # Assign the first cell the duration value and fill the remaining cells with 0 to block off the event
    # later these 0 values will get converted to NA and filtered out
    E[temp_rnum,(temp_startd + temp_pos_key)] <- temp_dur # set first value as temp_dur
    E[temp_rnum,((temp_startd + temp_pos_key + 1):(temp_startd + temp_dur - 1 + temp_pos_key))] <- 0 # set remaining values as 0 (to block off)
    E[temp_rnum,(temp_startd + temp_dur + temp_pos_key)] <- 0 # enforces a space between subsequent events
    
    # Update progress bar if processing multiple events
    if (nrow(event_subset) > 1) {
      setTxtProgressBar(progress_bar, idx)
    }
  }
  
  # trim unused rows
  E_ind <- rowSums(is.na(E))==(ncol(E)-2) # identify rows where all but priority and rnum are NA
  E <- E[ !E_ind, ]
  
  E[E == 0] <- NaN # remove spaces added to avoid events appearing connected
  
  E <- E[,priority:=NULL] # drop priority column
  plot_dat <- melt(E, measure.vars=colnames(E)[1:(ncol(E)-1)], # all but last column (rnum)
                   variable.name="names",value.name = "duration")
  plot_dat[,dt:=as.integer(str_remove(names,"V"))]
  plot_dat[,date:=as.Date(start_period + dt - 1)]
  plot_dat[,rnum:=rnum - n]
  plot_dat <- na.omit(plot_dat)
  
  # drop names and dt columns
  plot_dat <- plot_dat[,names:=NULL]
  plot_dat <- plot_dat[,dt:=NULL]
  
  plot_dat_df <- as.data.frame(plot_dat)
  
  return(plot_dat_df)
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
  
  return(selected_chunks)
}
