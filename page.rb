class Page

	def parse_raw
		#onclick appears for each record only
	end
	
	def initialize
		@raw_html
		
		@players = Array.new(50)
		@ranks = Array.new(50)
		@ranked_scores = Array.new(50)
		@accuracies = Array.new(50)
		@total_scores = Array.new(50)
		@levels = Array.new(50)
		@play_counts = Array.new(50)
		@SS_counts = Array.new(50)
		@S_counts = Array.new(50)
		@A_counts = Array.new(50)
		@countries = Array.new(50) #TODO tricky to parse
	end
	
	#getters and setters
	attr_accessor :raw_html, :players, :ranks, :ranked_scores, :accuracies, :total_scores, :levels, :play_counts, :SS_counts, :S_counts, :A_counts, :countries
end