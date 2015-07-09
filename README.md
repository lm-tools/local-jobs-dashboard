# local-jobs-dashboard

This application sits behind HTTP basic auth.

## How to run

`dashing start`

## Requirements

Redis.

The environment variables it requires are:

* `HTTP_USERNAME`
* `HTTP_PASSWORD`
* `AUTH_TOKEN`: auth token to push information to this dashboard
* `REDISTOGO_URL`: redis URL
* `AREA_NAMES`: comma-separated names of the areas you are loading
* `JOBS_API_URL`: URL to our jobs API, probably `https://lm-tools-jobs-api.herokuapp.com`

## Search term CSV parser and data pusher

In order to update the data in the `search_terms` scrolling widget, you can:
- add the CSV file that you are interested in to the `scripts/data` folder
- have the following environment variables to be set to run that script:
  * `AUTH_TOKEN`
  * `FILE_NAMES`: comma-seperated names of your CSV files in the `scripts/data` folder
  * `AREA_NAMES`: comma-separated names of the areas you are loading CSVs for (important: should be in the same order as the corresponding `FILE_NAMES`)
  * `DASHBOARD_URL`
  * `WIDGET_ID`

The CSV parser is designed to work with the search term CSV data format received on July 8, 2015.
