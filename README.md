# Warehouse

This repository contains tools for managing Hack Club's data warehouse.

Currently it sync a few pieces of important data:

- Our Google Sheet with the results of our weekly Slack check-ins with club leaders
- All of the data from our Streak account
- _More to come!_

[Click here][schema_spreadsheet] to see the full schema of our warehouse. Note: you **must** have PostgreSQL 9.5 or later for this project to work.

[schema_spreadsheet]: https://docs.google.com/spreadsheets/d/13ozt8j9YEq8j7G_m4q5tjdc1c8TMsnKYa5_PGnXGfu4/edit

## Setup

There are a few important environment variables you must set for any of this to work.

In the plain text field below, I've included descriptions of each environment variable with example values. The format is as follows:

```
# This is a comment, you can safely ignore me.
# This is the second line of the comment.
ENVIRONMENT_VARIABLE_TO_SET=EXAMPLE_VALUE_GOES_HERE
```

Here's the full environment configuration:

```
# Key for the Google Sheet with the Slack check-ins
SLACK_CHECK_INS_SPREADSHEET_KEY=1XxhV9st8el-9Wl5LEEmwchOauIXUQUaiOcNlbD4essw

# The downloaded JSON service account key for Google Drive converted to base64.
#
# How to get this:
#
# 1. Create a project on Google Cloud Platform if you don't already have one
# 2. Go to https://console.cloud.google.com/apis/library and enable Google Drive
# 3. Go to https://console.cloud.google.com/apis/credentials and create a
#    service account key. Download the JSON file and base64 it.
#
# Quick note: you'll run into authentication errors if you forget to share your
# spreadsheets with the service account you created.
GOOGLE_SERVICE_ACCOUNT_KEY_BASE64=ew0KICAic29tZV9yYW5kb20iOiAiSlNPTiBmaWxlIiwNCiAgICJzb21lX3JhbmRvbSI6ICJKU09OIGZpbGUiDQp9
```

## License

See [`LICENSE`](LICENSE).
