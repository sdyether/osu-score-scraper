require 'csv'

class MyCSV
	def to_csv( data, base_dir = File.join(".", "data"), fname = generate_fname )
		uri = File.join(base_dir, fname)
		
		CSV.open(uri, "w") do |csv|
			data.each do |row|
				csv << row
			end
		end
		
		puts "Output written to: " + uri
	end
	
	def read_csv( base_dir = File.join(".", "data"), fname)
	
	end
	
	def generate_fname()
		t = Time.now
		
		name = [ "scoredata", 
		[t.year, t.month, t.day].join("-"), 
		[t.hour, t.min, t.sec].join("-") ].join("_") + ".csv"
		
		name
	end

end