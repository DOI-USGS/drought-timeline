# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [2.0.0] - 2026-08-17
 
Here we track upcoming changes.
 
### Added
- Added a change log
- USWDS government banner in the site header
- 404 page
- git templates and a pull request template

### Changed
- Updated dependencies; switch from Vue 2 to Vue 3
- Switched the build from Vue CLI to Vite
- Replaced Vuex with Pinia for window size state
- Removed old build files, and stopped tracking build output (`dist/`) in version control
- Components translated to composition API
- CSS definitions moved to assets and streamlined
- Refined interaction functions while maintaining same functionality
- Site moved to the water.usgs.gov/vizlab domain; updated all links and metadata to match
- References and authorship sections pulled into reusable components consistent with the Vizlab template, with their content moved into `src/assets/text/`
- References are now ordered alphabetically by author rather than numbered
- Updated the USGS header, footer, and prefooter link components to the current Vizlab versions
- Switched analytics to the shared Vizlab Google Analytics property
- Dropped unused dependencies and moved runtime dependencies out of `devDependencies`

### Fixed
- Corrected the structured data (JSON-LD) block in `index.html`, which was not valid JSON
- The 404 page's "main page" link now resolves to the app rather than the site root
- Removed duplicate reference entries numbering and redundant citation fields
- Removed console logging from the production build
 
## [1.0.0] - 2024-11-07
 
### Added

-Initial public release
