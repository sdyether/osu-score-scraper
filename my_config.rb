class MyConfig
	#here we store the messy stuff that goes along with web scraping
	
	#if everything is broken you probably need to update the 
	#token strings in this file for the altered html structure
	
	def initialize()
	
		@num_pages = 20 #how many pages to scrape
		@max_requests_per_min = 15 #be kind to server
		@intial_backoff_wait = 30
		@max_page_attempts = 4
		@records_per_page = 50
		@base_url = "http://osu.ppy.sh/p/playerranking/?m=0&s=3&o=1&page="
		
		@page_split_token = "onclick='document.location=\"/u/"
		
		@record_split_tokens = [ "\"'><td><b>#", "</b></td><td><img class='flag' src=\"//s.ppy.sh/images/flags/", ".gif\" title=\"\"/> <a href='/u/", "'>", "</a></td><td>", "%</td><td><span>", "</span></td><td><span>", " (", ")</span></td><td><span style='font-weight:bold'>", "</span></td><td align='center'>", "</td><td align='center'>", "</td><td align='center'>", "</td></tr>" ]
		#[ user id, rank, country code, user id, username, accuracy, play count, total score, level, ranked score, SS count, S count, A count ]
	
	end
	
	attr_reader :num_pages, :max_requests_per_min, :base_url, :intial_backoff_wait, \
	:max_page_attempts, :records_per_page,:page_split_token, :record_split_tokens
end