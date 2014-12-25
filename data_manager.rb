require_relative 'page'

class DataManager
	def self.flatten_pages( pages )
		#take an array of pages and return an array of row arrays
		data = []
		
		pages.each do |p|
			p.page_data.each do |row|
				data << row
			end
		end

		data
	end
end