require 'net/http'

class RankedScoreScraper

	def start()
		#main scraper method
		self.setup
		
	end
	
	def setup()
		#TODO these from config file instead
		@num_pages = 1
		@requests_per_min = 10
		@base_url = "https://osu.ppy.sh/p/playerranking/?m=0&s=3&o=1&page="
	end
	
	def initialize
		@num_pages #how many pages to scrape
		@requests_per_min #max server requests per minute
		@base_url
		@finished = false
	end
	
end





