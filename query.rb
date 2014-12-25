#!/usr/bin/env ruby

require 'fileutils'
#require_relative 'ranked_score_scraper'
require_relative 'my_csv'
#require_relative 'my_config'

def print_help
	puts "\nOptional flags:\n\t'--sort': primary sorting field, should be a conditional flag name from below.  Defaults to 'rankedScore'.\n\t'--limit': Optional limit on amount of results returned.  Defaults to infinity.\n\nConditional flags:\n\t'id'\n\t'rank'\n\t'country'\n\t'username'\n\t'accuracy'\n\t'playCount'\n\t'totalScore'\n\t'level'\n\t'rankedScore'\n\t'ssCount'\n\t'sCount'\n\t'aCount'\n\nExamples:\n\t'ruby query.rb --sort accuracy --country au --limit 10' #get top 10 australian players sorted by accuracy\n\t'ruby query.rb --sort totalScore --level 103' #get all level 103 players sorted by total score\n"
end

if ARGV.include? "--help"
	print_help
	abort
end

args = ARGV.each_slice(2).to_a

keys = %w(id rank country username accuracy playCount totalScore level rankedScore ssCount sCount aCount)
#[ user id, rank, country code, user id, username, accuracy, play count, total score, level, ranked score, SS count, S count, A count ]
conditions = []
limit = nil
sort = nil

args.each do |a|
	if !a[1]
		puts "Error: mismatching arguments."
		print_help
		abort
	end
	
	case a[0]
	when "--limit"
		limit = a[1].to_i
	when "--sort"
		sort = a[1]
	else
		if !keys.include?( a[0][2..-1] )
			puts "Error: unsupported argument: " + a[0][2..-1]
			print_help
			abort
		else
			#add as condition (pair) to match
			conditions << [a[0][2..-1], a[1]]
		end
	end
end

limit ||= 1000
sort ||= "rankedscore"

#arguments done, get our data:
data = MyCSV.read_csv( MyCSV.get_latest )

#remove data that doesn't match all conditions
conditions.each do |cond|
	index = keys.index cond[0]
	tmp = data.dup
	data.each do |row|
		if row[index] != cond[1]
			tmp.delete(row)
		end
	end
	data = tmp
end

#sort data
data.each do |row|
	[0, 1, 5, 6, 7, 8, 9, 10, 11].each do |x|
		row[x] = row[x].to_i #some fields should be int for sorting
	end
	row[4] = row[4].to_f #accuracy needs to be float
end

data.sort_by! {|k| -k[keys.index( sort )] }

#apply final limit
data = data[0...limit]

#print final data
puts
data.each {|d| p d } #TODO make this prettier
