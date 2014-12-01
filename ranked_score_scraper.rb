require 'net/http'
require_relative 'page'
require_relative 'page_window'
require_relative 'data_manager'

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
				
				@window.fix_everything #corner case
				
			end
			
			#we should now have a valid current page
			@pages[pages_done].save_page( @window.curr )
			@window.prev = @window.curr
			pages_done += 1

		end
		
		#success
		puts "Finished."
		return DataManager.flatten_pages( @pages )
		
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
			puts "Grabbing page: " + url + "..."
			
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
	
	def initialize( config )
	
	#TODO https://github.com/hexorx/countries
	
		@num_pages = config.num_pages
		@max_requests_per_min = config.max_requests_per_min
		@intial_backoff_wait = config.intial_backoff_wait
		@max_page_attempts = config.max_page_attempts
		@records_per_page = config.records_per_page
		
		@base_url = config.base_url
		@page_split_token = config.page_split_token
		@record_split_tokens = config.record_split_tokens
		
		@window = PageWindow.new
		@window.window_size = 2
		
		#let's keep all pages in memory so we can rollback easier on failed scrape
		@pages = Array.new(@num_pages)
		(0...@num_pages).each do |x|
			@pages[x] = Page.new
		end
		
	end
	
	#getters and setters 
	attr_accessor :num_pages, :max_requests_per_min, :base_url, :intial_backoff_wait, \
	:max_page_attempts, :records_per_page, :pages, :page_split_token, :record_split_tokens

end





