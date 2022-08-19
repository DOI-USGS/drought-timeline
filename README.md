# 70 years of drought in the U.S.

## To run locally
Clone the repo. In the directory, run `npm install` to install the required modules. This repository requires `npm v14.17.0` to run. If you are using a later version of `npm`, you may [try using `nvm` to manage multiple versions of npm](https://betterprogramming.pub/how-to-change-node-js-version-between-projects-using-nvm-3ad2416bda7e).

Once the dependencies have been installed, run `npm run serve` to run locally from your browser.

## Set up ScienceBase credentials 

In order to download the data from ScienceBase while the data release remains unpublished, you will need to first set up local credentials by running the following chunk of code with your own ScienceBase username. You will be prompted for a password (this should be your AD password if you are a USGS employee) in a separate dialogue box. This only needs to be run once for as long as your username and password are valid. Re-run when you need to update your password.

```r
library(secret);library(dplyr)
source("0_config/src/authentication_helpers.R")
set_up_auth("your_email@usgs.gov")
```

## Disclaimer

This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey, an agency of the United States Department of Interior. For more information, see the official USGS copyright policy at [http://www.usgs.gov/visual-id/credit_usgs.html#copyright](http://www.usgs.gov/visual-id/credit_usgs.html#copyright)

This information is preliminary or provisional and is subject to revision. It is being provided to meet the need for timely best science. The information has not received final approval by the U.S. Geological Survey (USGS) and is provided on the condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from the authorized or unauthorized use of the information. Although this software program has been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided "AS IS."


[
  ![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)
](http://creativecommons.org/publicdomain/zero/1.0/)
