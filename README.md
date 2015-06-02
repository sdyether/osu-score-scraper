A simple web scraper for some osu! statistics, necessitated by limits of the official API

Requires Ruby 1.9+

### Instructions:
1. Download zip, extract and cd to directory
2. Run `ruby main.rb` to take a snapshot of the data
3. Run `ruby query.rb --help` for info on how to form queries of the saved data.  An example is `ruby query.rb --sort ssCount --country au --limit 20`

### Todo:
* Make use of CSV snapshots to graph changes in stats for users
* General refactoring