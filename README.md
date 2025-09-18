# Five droughts that changed U.S. history

**The data visualization website can be viewed at [https://water.usgs.gov/vizlab/drought-timeline](https://water.usgs.gov/vizlab/drought-timeline).**

## To build pipeline and reproduce figures
Clone the repo. In RStudio, run `library(targets)` and `tar_make()`. This will require ScienceBase credentials to run, see instructions below.

## Set up ScienceBase credentials 

In order to download the data from ScienceBase while the data release remains unpublished, you will need to first set up local credentials by running the following chunk of code with your own ScienceBase username. You will be prompted for a password (this should be your AD password if you are a USGS employee) in a separate dialogue box. This only needs to be run once for as long as your username and password are valid. Re-run when you need to update your password.

```r
library(secret);library(dplyr)
source("0_config/src/authentication_helpers.R")
set_up_auth("your_email@usgs.gov")
```

## Building the website locally

Clone the repo. In the directory, run `npm install` to install the required modules. Once the dependencies have been installed, run `npm run dev` to run locally from your browser.

To build the website locally you'll need `node.js` `v22.14.0` and `npm` `v10.9.2` or higher installed. To manage multiple versions of `npm`, you may [try using `nvm`](https://betterprogramming.pub/how-to-change-node-js-version-between-projects-using-nvm-3ad2416bda7e).

## Citation

B22.	Corson-Dosch, H., Archer, A., Azadpour, E., Carr, A., and Nell, C. Five droughts that changed U.S. history. U.S. Geological Survey website. Reston, VA. [https://water.usgs.gov/vizlab/drought-timeline](https://doi.org/https://water.usgs.gov/vizlab/drought-timeline)

## Consulting subject matter experts
Scott Hamshaw, Caelan Simeone, and John Hammond consulted on the development of this website as subject matter experts.

## Additional information
* We welcome contributions from the community. See the [guidelines for contributing](https://github.com/DOI-USGS/drought-timeline/) to this repository on GitHub.
* [Disclaimer](https://github.com/DOI-USGS/drought-timeline/blob/main/DISCLAIMER.md)
* [License](https://code.usgs.gov/wma/vizlab/drought-timeline/-/blob/main/LICENSE.md)

