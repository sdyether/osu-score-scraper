require_relative 'page'

class PageWindow

	def self.valid_page_window?( page1, page2 )
		# We need to do this because the website can update during scraping.
		# eg a player may have been #51 (page 2) when we scraped page 1, 
		# but by the time we get to scraping page 2 they could be #50 (page 1)
		# -> need to rescrape page 1 to not miss them
		
		#grab key field
		ids1 = page1.map{ |row| row[0] }
		ids2 = page2.map{ |row| row[0] }
		
		arr = ids1 + ids2
		arr_nodups = arr.uniq
		
		if arr.length == arr_nodups.length
			true
		else
			false
		end
	
	end
	
	def fix_everything
	
	end

	def initialize
		@curr
		@prev
		
		@curr_new
		@prev_new
		
		@window_size
		
	end
	
	def window_size=(num)
		if num == 2
			@window_size = num
		else
			raise ArgumentError, "Only supports window size of 2 currently"
		end
	end
	
	attr_reader :window_size
	
	attr_accessor :prev, :curr, :prev_new, :curr_new

end