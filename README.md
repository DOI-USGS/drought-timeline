# 100 years of drought in the U.S.

## To run locally
Clone the repo. In the directory, run `npm install` to install the required modules. This repository requires `npm v20` to run. If you are using a later version of `npm`, you may [try using `nvm` to manage multiple versions of npm](https://betterprogramming.pub/how-to-change-node-js-version-between-projects-using-nvm-3ad2416bda7e).

Once the dependencies have been installed, run `npm run serve` to run locally from your browser.

## Set up ScienceBase credentials 

In order to download the data from ScienceBase while the data release remains unpublished, you will need to first set up local credentials by running the following chunk of code with your own ScienceBase username. You will be prompted for a password (this should be your AD password if you are a USGS employee) in a separate dialogue box. This only needs to be run once for as long as your username and password are valid. Re-run when you need to update your password.

```r
library(secret);library(dplyr)
source("0_config/src/authentication_helpers.R")
set_up_auth("your_email@usgs.gov")
```

