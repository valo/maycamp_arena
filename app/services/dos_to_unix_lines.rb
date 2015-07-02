class DosToUnixLines
	def initialize path_to_file, path_to_result
		@path1 = path_to_file
		@path2 = path_to_result
	end

	def call
		text = File.read(@path1)
		converted = text.gsub /\r\n?/, "\n"
		File.open(@path2, 'w') { |file| file.write(converted) }
	end

private
attr_reader :path_to_file, :path_to_result

end
