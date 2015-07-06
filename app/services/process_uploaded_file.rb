class ProcessUploadedFile
  def initialize file, problem
    @problem = problem
    @upload = file
  end

  def extract
    # Create the folders if they doesn't exist
    FileUtils.mkdir_p(@problem.tests_dir)

    if @upload.original_filename.end_with?("zip")
      zip_extract
    else
      file_extract
    end
    convert_lines
  end

  def zip_extract
      # Extract the bundle
    Zip::ZipFile.foreach(@upload.tempfile.path) do |filename|

      if filename.file? and !filename.name.include?('/')
        dest = File.join(@problem.tests_dir, filename.name)
        FileUtils.rm(dest) if File.exists?(dest)
        filename.extract dest
      end
    end  
  end

  def file_extract
    dest = File.join(@problem.tests_dir, @upload.original_filename)
    FileUtils.cp @upload.path, dest
    # Set the permissions of the copied file to the right ones. This is
    # because the uploads are created with 0600 permissions in the /tmp
    # folder. The 0666 & ~File.umask will set the permissions to the default
    # ones of the current user. See the umask man page for details
    FileUtils.chmod 0666 & ~File.umask, dest
  end

  def convert_lines
    @problem.input_files.each do |filename|
        #puts filename
        to_converted = Tempfile.new('temp')

        file_path = File.path(filename)
        path_to_converted = File.path(to_converted)

        DosToUnixLines.new(file_path, path_to_converted).call
        IO.copy_stream(path_to_converted, file_path)
        to_converted.close
    end
    @problem.output_files.each do |filename|
        to_converted = Tempfile.new('temp')

        file_path = File.path(filename)
        path_to_converted = File.path(to_converted)

        DosToUnixLines.new(file_path, path_to_converted).call
        IO.copy_stream(path_to_converted, file_path)
        to_converted.close
    end
  end


private
  attr_reader :file, :problem
end