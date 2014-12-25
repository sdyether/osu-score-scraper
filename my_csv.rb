require 'csv'

class MyCSV
	def self.to_csv( data, base_dir = File.join(".", "data"), fname = generate_fname )
		uri = File.join(base_dir, fname)
		
		CSV.open(uri, "w") do |csv|
			data.each do |row|
				csv << row
			end
		end
		
		puts "Output written to: " + uri
	end
	
	def self.read_csv( base_dir = File.join(".", "data"), fname)
		uri = File.join(base_dir, fname)
		
		data = []
		CSV.foreach(uri) do |line|
			data << line
		end
		
		data
	end
	
	#return filename of most recent data set
	def self.get_latest( base_dir = File.join(".", "data") )
	
		if !File.directory?(base_dir)
			puts "No data yet, try running the scraper with 'ruby main.rb'"
			return nil
		end
		
		file = Dir.glob(File.join(base_dir, "*")).max_by {|f| File.mtime(f)}
		return File.basename(file)
		
	end
	
	def self.generate_fname()
		t = Time.now
		
		name = [ "scoredata", 
		[t.year, t.month, t.day].join("-"), 
		[t.hour, t.min, t.sec].join("-") ].join("_") + ".csv"
		
		name
	end

end