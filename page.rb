class Page

	def parse_raw_html(split_token, record_splitters)

		segments = @raw_html.split(split_token)
		
		finalrecords = []
		#segments[1...segments.length].each do |s|	#segments[0] can be discarded
		segments[1...5].each do |s|	#segments[0] can be discarded
			puts s
			print "\n" * 5
			#finalrecords.push(segments[s].split("'").first)
		end
	end
	
	def save_page
	
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