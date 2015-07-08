# local-jobs-dashboard

This application sits behind HTTP basic auth.
The environment variables it requires are:

* `HTTP_USERNAME`
* `HTTP_PASSWORD`
* `AUTH_TOKEN`: auth token to push information to this dashboard

## Search term CSV parser and data pusher

In order to update the data in the `search_terms` scrolling widget, you can:
- add the CSV file that you are interested in to the `scripts/data` folder
- have the following environment variables to be set to run that script:
  * `AUTH_TOKEN`
  * `FILE_NAME`: name of your CSV file in the `scripts/data` folder
  * `DASHBOARD_URL`
  * `WIDGET_ID`

The CSV parser is designed to work with the search term CSV data format received on July 8, 2015.
