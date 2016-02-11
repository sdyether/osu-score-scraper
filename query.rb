#!/usr/bin/env ruby

require 'fileutils'
require_relative 'my_csv'

def print_help
	puts "\nOptional flags:\n\t'--sort': primary sorting field, should be a searchable flag name from below.  Defaults to 'rankedScore'.\n\t'--limit': Optional limit on amount of results returned.  Defaults to 50.\n\nSearchable flags:\n\t'id'\n\t'rank'\n\t'country'\n\t'username'\n\t'accuracy'\n\t'playCount'\n\t'totalScore'\n\t'level'\n\t'rankedScore'\n\t'ssCount'\n\t'sCount'\n\t'aCount'\n\nExamples:\n\t'ruby query.rb --sort accuracy --country au --limit 10'  #get top 10 australian players sorted by accuracy\n\t'ruby query.rb --sort totalScore --level 103'  #get all level 103 players sorted by total score\n\nThere is also a minimal flag now that prints only the relevant sort criteria.  Expect it to break though.\n\tEg: 'ruby query.rb --sort ssCount --limit 20 --minimal true   #find the perfectionists"
end

def print_header
	puts
	header = "User ID, Rank, Country, Username,  Accuracy,  Playcount,  Total Score,  Level, Ranked Score,  SS's,  S's,  A's"
	puts header
	puts "-" * header.size
end

def print_mini_header(sort)
	puts
	header = "Username,         " + sort + "   "
	puts header
	puts "-" * header.size
end

if ARGV.include? "--help"
	print_help
	abort
end

args = ARGV.each_slice(2).to_a

keys = %w(id rank country username accuracy playCount totalScore level rankedScore ssCount sCount aCount)
#[ user id, rank, country code, user id, username, accuracy, play count, total score, level, ranked score, SS count, S count, A count ]

conditions = []
limit = nil #for printing less results
sort = nil
minimal = nil 
#for printing only relevant fields in each row
#dodgy addition that might break things if you are sorting by more than one cond

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
	when "--minimal"
		minimal = true
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

limit ||= 50
sort ||= "rankedScore"
minimal ||= false

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
case minimal
when false
	print_header
	data.each do |row|
		row.each_with_index do |x, index|
			#make each column appropriately sized for console tabular printing
			print x.to_s.ljust(data.transpose[index].map(&:to_s).group_by(&:size).max.last.last.size + 3)
		end
		print "\n"
	end 
when true
	print_mini_header(sort)
	data.each do |d|
		puts d[3].ljust(20) + d[keys.index( sort )].to_s
	end
else
	puts "Something went wrong"
end
