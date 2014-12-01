#!/usr/bin/env ruby

require 'fileutils'
require_relative 'ranked_score_scraper'
require_relative 'my_csv'
require_relative 'my_config'

config = MyConfig.new

#scrape data
scraper = RankedScoreScraper.new(config)
data = scraper.start

#save

data_dir = File.join(Dir.pwd, "data")

unless File.directory?(data_dir)
	FileUtils.mkdir_p(data_dir)
end

csv = MyCSV.new
csv.to_csv( data, data_dir )