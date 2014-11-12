class Page

	def parse_raw
	
	end
	
	def initialize
		@raw_html
		
		@players = Array.new(50)
		@ranks = Array.new(50)
		@ranked_scores = Array.new(50)
		@accs = Array.new(50)
		@total_scores = Array.new(50)
		@levels = Array.new(50)
		@play_counts = Array.new(50)
		@SS_counts = Array.new(50)
		@S_counts = Array.new(50)
		@A_counts = Array.new(50)
	end
end