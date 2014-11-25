require 'net/http'
require_relative 'page'
require_relative 'page_window'

class RankedScoreScraper

	#main scraper method
	def start()
	
		pages_done = 0
		while pages_done < @num_pages
		
			@window.curr = get_and_parse(pages_done + 1)
			
			if pages_done == 0
				#first page don't need to check for bad window
				@pages[pages_done].save_page( @window.curr )
				@window.prev = @window.curr
				pages_done += 1
				next
			end
			
			if not PageWindow.valid_page_window?( @window.prev, @window.curr )
				
				puts "Site update detected"
				
				loop do
					@window.prev_new = get_and_parse( pages_done )
					@window.curr_new = get_and_parse( pages_done + 1 )
					
					break if PageWindow.valid_page_window?( @window.prev_new, @window.curr_new )
				end
				
				@window.fix_everything #magic
				
			end
			
			#we should now have a valid current page
			@pages[pages_done].save_page( @window.curr )
			@window.prev = @window.curr
			pages_done += 1

		end
		
		#success
		puts "Finished."

	end
	
	def get_and_parse(num) #1-indexed
	
		if !(num.between?(1, @num_pages))
			raise ArgumentError, "Invalid page"
		end
		
		#download a page
		data = self.class.get_page_html( 
			@base_url + (num).to_s, 
			@max_page_attempts, 
			max_requests_per_min, 
			@intial_backoff_wait )
			
		if !(data)
			abort( "Error: Page " + (num).to_s + " could not be retrieved.  Exiting." )
		end
		
		#parse page
		data = Page.parse_raw_html(data, @page_split_token, @record_split_tokens)
		if !( data )
			abort( "Error: Could not process page " + (cur_page + 1).to_s + ".  Exiting." )
		end
		
		data
		
	end

	#return a page html
	def self.get_page_html(url, max_attempts = 4, max_requests_per_min = 15, intial_backoff_wait = 30 )
		
		attempt_number = 1
		
		while (attempt_number <= max_attempts)
		
			#try to get a page
			puts "Grabbing page " + url + "..."
			
			url = URI.parse(url)
			req = Net::HTTP::Get.new(url.to_s)
			response = Net::HTTP.start(url.host, url.port) do |http|
				http.request(req)
			end

			if response.code == "200"
				puts "Success.\n"
				sleep(60/max_requests_per_min) #sleep here
				return response.body #success
			end
			
			sleep(intial_backoff_wait * attempt_number) #binary backoff
			attempt_number += 1
			#try again
		end
		
		return nil #failed
	end
	
	def initialize
	#TODO get these from config file instead
	
		@num_pages = 2 #how many pages to scrape
		@max_requests_per_min = 15 #be kind to server
		@base_url = "http://osu.ppy.sh/p/playerranking/?m=0&s=3&o=1&page="
		@intial_backoff_wait = 30
		@max_page_attempts = 4
		@records_per_page = 50
		
		@page_split_token = "onclick='document.location=\"/u/"
		
		@record_split_tokens = [ "\"'><td><b>#", "</b></td><td><img class='flag' src=\"//s.ppy.sh/images/flags/", ".gif\" title=\"\"/> <a href='/u/", "'>", "</a></td><td>", "%</td><td><span>", "</span></td><td><span>", " (", ")</span></td><td><span style='font-weight:bold'>", "</span></td><td align='center'>", "</td><td align='center'>", "</td><td align='center'>", "</td></tr>" ]
		#[ user id, rank, country code, user id, username, accuracy, play count, total score, level, ranked score, SS count, S count, A count ]
		
		@window = PageWindow.new
		@window.window_size = 2
		
		#let's keep all pages in memory so we can rollback easier on failed scrape
		@pages = Array.new(@num_pages)
		(0...@num_pages).each do |x|
			@pages[x] = Page.new
		end
		
	end
	
	#getters and setters 
	attr_accessor :num_pages, :max_requests_per_min, :base_url, :intial_backoff_wait, :max_page_attempts, :records_per_page, :pages, :page_split_token, :record_split_tokens

end





