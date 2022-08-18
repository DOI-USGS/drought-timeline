source("1_fetch/src/sb_fetch_helpers.R")

p1_targets <- list(
  ##### Fetch data from parent item #####
  tar_target(p1_metadata_csv,
             download_sb_files(sb_id = p0_sbitem_parent,
                               sb_files_to_download = 'gagesII_metadata_study.csv',
                               dest_dir = "1_fetch/out",
                               sb_secret_exists = p0_sb_credentials_exist)
  ),
  
  ##### Fetch data from child item 1951-2020 #####
  
  ###### Download drought properties files ######
  tar_target(p1_1951_2020_drought_prop_site_csv, {
    # Depend on this dummy variable to initiate re-download of files
    p0_sb_fetch_date
    download_sb_files(sb_id = p0_sbitem_child_1951_2020,
                      sb_files_to_download = 'Drought_Properties_site_updated.csv',
                      dest_dir = "1_fetch/out/CONUS_1951_2020",
                      sb_secret_exists = p0_sb_credentials_exist)
  },
  format = 'file'),
  tar_target(p1_1951_2020_drought_prop_jd_7d_csv, {
    # Depend on this dummy variable to initiate re-download of files
    p0_sb_fetch_date
    download_sb_files(sb_id = p0_sbitem_child_1951_2020,
                      sb_files_to_download = 'Drought_Properties_jd_07d_wndw_updated.csv',
                      dest_dir = "1_fetch/out/CONUS_1951_2020",
                      sb_secret_exists = p0_sb_credentials_exist)
  },
  format = 'file')
)