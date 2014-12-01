class Page

	FIELDS = 12
	RECORDS = 50

	def self.parse_raw_html(raw_html, split_token, record_splitters)

		segments = raw_html.split(split_token)
		final_records = []
		
		segments[1...segments.length].each do |s|	#segments[0] can be discarded

			record_values = []
			record_splitters.each do |r|
				splat = s.split(r, 2) #split only once
				
				#chomp the value and move on to next
				record_values.push(splat[0])
				s = splat[1]
			end

			record_values.delete_at(3) #remove a dup
			final_records.push(record_values)
		end

		final_records #return all records
	end
	
	def save_page(data) 

		#p data.map{ |row| row[2] }
		
		self.class.valid_page?( data )
	
		data = self.class.validate( data )
		
		@page_data = data

	end
	
	def self.valid_page?( page )

		if page.length != RECORDS
			raise RuntimeError.new "Error in page format: Not enough records. Exiting."
		end
		
		page.each do |p|
			if p.length != FIELDS
				raise RuntimeError.new "Error in page format at record: " + p[3] + ". Exiting."
			end
		end

	end
	
	def self.validate( page )

		page.each do |r|
			#delete commas from number fields they appear in
			[5, 6, 8, 9, 10, 11].each do |f|
				r[f].delete!(',')
			end
		end
		
		page
	
	end
	
	def initialize()
		
		@page_data = [] 
		
		# format:
		
		#[ 	user id, 		0
		#	rank, 			1
		#	country code, 	2
		#	username, 		3
		#	accuracy, 		4
		#	play count, 	5
		#	total score, 	6
		#	level, 			7
		# 	ranked score,  	8
		#	SS count, 		9
		#	S count, 		10
		#	A count ]		11

	end
	
	#getters and setters
	attr_reader :page_data
	
	def page_data=(data)
		save_page(data)
	end
end