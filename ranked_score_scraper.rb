require 'net/http'
require_relative 'page'

class RankedScoreScraper

	def start()
		#main scraper method
		setup()
		
		cur_page = 1
		while cur_page <= @num_pages
		
			@pages[cur_page - 1] = get_page(cur_page)
			if !(@pages[cur_page - 1])
				abort( "Error: page " + cur_page.to_s + " could not be retrieved.  Exiting." )
			end
			
			cur_page += 1
			sleep(60/@max_requests_per_min)
		end
		
		puts @num_pages.to_s + " pages successfully scraped."
		#puts @pages[0].raw_html
		
		#change this to parse each grab
		@pages.each do |page|
			page.parse_raw_html(@page_split_token, @record_split_tokens)
		end
		
	end
	
	#return a Page with raw html
	def get_page(num)
		
		attempt_no = 1
		
		while (attempt_no <= @max_page_attempts)
		
			#try to get a page
			puts "Grabbing page " + num.to_s + " ..."
			
			url = @base_url + num.to_s
			
			url = URI.parse(url)
			req = Net::HTTP::Get.new(url.to_s)
			response = Net::HTTP.start(url.host, url.port) do |http|
				http.request(req)
			end

			if response.code == "200"
				page = Page.new
				page.raw_html = response.body
				puts "Success."
				return page #success
			end
			
			sleep(@intial_backoff_wait * attempt_no) #binary backoff
			attempt_no += 1
			#try again
		end
		
		return nil #failed
	end
	
	def setup()
		#TODO get these from config file instead
		@num_pages = 1
		@max_requests_per_min = 10
		@base_url = "http://osu.ppy.sh/p/playerranking/?m=0&s=3&o=1&page="
		@intial_backoff_wait = 30
		@max_page_attempts = 4
		@records_per_page = 50
		@page_split_token = "onclick='document.location=\"/u/"
		
		@record_split_tokens = [ "\"'><td><b>#", "</b></td><td><img class='flag' src=\"//s.ppy.sh/images/flags/", ".gif\" title=\"\"/> <a href='/u/", "'>", "</a></td><td>", "%</td><td><span>", "</span></td><td><span>", " (", ")</span></td><td><span style='font-weight:bold'>", "</span></td><td align='center'>", "</td><td align='center'>", "</td><td align='center'>" ]
		#[ user id, rank, country code, user id, username, accuracy, play count, total score, level, ranked score, SS count, S count, A count ]
		
		@pages = Array.new(@num_pages)
	end
	
	def initialize
		@num_pages #how many pages to scrape
		@max_requests_per_min #be kind to server
		@base_url
		@finished = false
		@intial_backoff_wait
		@max_page_attempts
		@records_per_page
		@page_split_token
		@record_split_tokens
		
		#let's keep all pages in memory so we can rollback easier on failed scrape
		@pages
	end
	
	#getters and setters 
	attr_accessor :num_pages, :max_requests_per_min, :base_url, :finished, :intial_backoff_wait, :max_page_attempts, :records_per_page, :pages, :page_split_token, :record_split_tokens
	
end





