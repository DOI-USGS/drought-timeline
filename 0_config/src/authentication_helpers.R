#########################################################################################################
# PULLED FROM: 
# https://code.usgs.gov/wma/proxies/habs/wq-data-prep/-/blob/main/0_config/src/authentication_helpers.R 
#########################################################################################################


#' @description One time action to set up local credentials in an existing repo vault. It
#' is only needed once (or when you need to update a password) and will prompt you for a
#' password in a pop-up dialogue box. To update an existing secret, pass in the same 
#' `user_email` and `secret_name`. It will automatically update the secret with the new
#' password that you enter into the dialogue box.
#' @param user_email character string with the email for the user adding a secret
#' @param secret_name character string given to the name of the secret being stored. By
#' default, this is `"sciencebase"`, but could be something different. Accepting the default
#' will allow `has_sb_credentials()` and `login_with_local_sb_credentials()` to operate
#' without any inputs.
#' @param vault character string representing the path to the vault where a secret should
#' be created. By default, this is `"sb.vault"`, but could be something different. Accepting
#' the default will allow `has_sb_credentials()` and `login_with_local_sb_credentials()` to
#' operate without any inputs.
#' @return a character string with the name of the secret that was created successfully
set_up_auth <- function(user_email, secret_name = "sciencebase", vault = "sb.vault") {
  
  # Skip adding a user if they exist already:
  if(!user_email %in% list_users(vault)) {
    # Add the user
    add_user(user_email, local_key(), vault = vault)
  }
  
  password <- rstudioapi::askForPassword()
  
  # Update the secret if it exists already:
  existing_secrets <- list_secrets(vault) %>%
    filter(email == user_email) %>%
    pull(secret)
  if(!secret_name %in% existing_secrets) {
    # Add the secret
    add_secret(secret_name, password, users = user_email, vault = vault)
  } else {
    # Update secret (don't bother checking if it is even
    # different than what is already in the vault)
    update_secret(secret_name, password, vault = vault)
  }
  
  # NOTE: If running on a shared machine, consider adding a call to 
  # `system("chmod g-rwx <filename>")` to edit file permissions to 
  # avoid secrets being read by others that have access to the shared 
  # directory. If running on Windows, that function call may need edits.
  
  return(secret_name)
}

#' @description Lookup an existing secret and return the username and password.
#' @param secret_name character string given to the name of the secret being stored. By
#' default, this is `"sciencebase"`, but could be something different. 
#' @param vault character string representing the path to the vault where a secret should
#' be created. By default, this is `"sb.vault"`, but could be something different. 
#' @return a list with two entries, `username` and `password`. Both contain a character string.
reveal_secret <- function(secret_name = "sciencebase", vault = "sb.vault") {
  list(
    username = list_owners(secret_name, vault),
    password = get_secret(secret_name, vault = vault)
  )
}

#' @description Determine whether a secret exists for ScienceBase. Fail and prompt a user to
#' look at the repo README for instructions with how to set one up. For `targets` pipelines,
#' you can use this as a command in a `tar_target()` that will fail early if the pipeline user
#' has not setup credentials yet.
#' @param secret_name character string given to the name of the secret being stored. By
#' default, this is `"sciencebase"`, but could be something different. 
#' @param vault character string representing the path to the vault where a secret should
#' be created. By default, this is `"sb.vault"`, but could be something different. 
#' @return if there is a secret, this function will return the logical value `TRUE`. If there
#' is not an existing secret, it will fail and return nothing. 
has_sb_credentials <- function(secret_name = "sciencebase", vault = "sb.vault") {
  returned_secret <- tryCatch(
    reveal_secret(secret_name, vault),
    error = function(e) {
      stop("No ScienceBase credentials found. Follow README instructions for setting up ScienceBase credentials. Then, try building the pipeline again.")
    })
  return(TRUE)
}

#' @description Use an existing secret to login to ScienceBase in the current R session. Typically,
#' this is called from within a function that is using `sbtools` functions to interact with ScienceBase.
#' @param secret_name character string given to the name of the secret being stored. By
#' default, this is `"sciencebase"`, but could be something different. 
#' @param vault character string representing the path to the vault where a secret should
#' be created. By default, this is `"sb.vault"`, but could be something different. 
#' @return Nothing is returned, but the user is logged in. If the login fails, this should fail.
login_with_local_sb_credentials <- function(secret_name = "sciencebase", vault = "sb.vault") {
  # First verify that you are logged into SB. Need to do this for each task that calls
  # Use the local credentials that were set up with `set_up_auth()`
  if(!sbtools::is_logged_in()){
    sb_secret <- reveal_secret(secret_name, vault) # Find the local credentials
    sbtools::authenticate_sb(username = sb_secret$username, password = sb_secret$password)
  }
}
