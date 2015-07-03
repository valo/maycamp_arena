class DosToUnixLines
  def initialize source_filepath, destination_filepath
    @source_filepath = source_filepath
    @destination_filepath = destination_filepath
  end

  def call
    text = File.read(@source_filepath)
    converted = text.gsub /\r\n?/, "\n"
    File.open(@destination_filepath, 'w') { |file| file.write(converted) }
  end

private
  attr_reader :source_filepath, :destination_filepath

end
