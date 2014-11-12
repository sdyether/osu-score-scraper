require 'net/http'
require_relative 'page'

class RankedScoreScraper

	def start()
		#main scraper method
		self.setup
		
		cur_page = 1
		while cur_page <= @num_pages
			get_page(cur_page)
			cur_page++
		end
		
	end
	
	#return a Page with raw html
	def get_page(num)
		
		attempt_no = 1
		#max_page_attempts = 4
		#intial_backoff_wait = 30 #seconds
		
		while attempt_no <= @max_page_attempts
		
			#try to get a page
			url = @base_url + num.to_s
			
			url = URI.parse(url)
			req = Net::HTTP::Get.new(url.to_s)
			response = Net::HTTP.start(url.host, url.port) do |http|
				http.request(req)
			end
			
			if response.code == "200"
				page = Page.new
				page.raw_html = response.body
				return page
			end
			
			sleep(@intial_backoff_wait * attempt_no)
			attempt_no++
			#try again
		end
		
		return nil
	end
	
	def setup()
		#TODO get these from config file instead
		@num_pages = 1
		@requests_per_min = 10
		@base_url = "https://osu.ppy.sh/p/playerranking/?m=0&s=3&o=1&page="
		@intial_backoff_wait = 30
		@max_page_attempts = 4
		@records_per_page = 50
		
		@pages = Array.new(@num_pages) { Page.new }
	end
	
	def initialize
		@num_pages #how many pages to scrape
		@requests_per_min #max server requests per minute
		@base_url
		@finished = false
		@intial_backoff_wait
		@max_page_attempts
		@records_per_page
		
		#let's keep all pages in memory so we can rollback easier on failed scrape
		@pages
	end
	
end





