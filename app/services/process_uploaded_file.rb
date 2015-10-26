class ProcessUploadedFile
  def initialize uploaded_file, problem
    @problem = problem
    @uploaded_file = uploaded_file
  end

  def extract

    create_test_dir
    if is_zip?
      zip_extract
    else
      file_extract
    end

    convert_lines
  end

private
  attr_reader :uploaded_file, :problem

  def zip_extract
    # Extract the bundle
    Zip::ZipFile.foreach(uploaded_file.tempfile.path) do |filename|

      if filename.file? and !filename.name.include?('/')
        dest = File.join(problem.tests_dir, filename.name)
        FileUtils.rm(dest) if File.exists?(dest)
        filename.extract dest
      end
    end
  end

  def file_extract
    dest = path_to_files
    FileUtils.cp uploaded_file.path, dest
    # Set the permissions of the copied file to the right ones. This is
    # because the uploads are created with 0600 permissions in the /tmp
    # folder. The 0666 & ~File.umask will set the permissions to the default
    # ones of the current user. See the umask man page for details
    FileUtils.chmod 0666 & ~File.umask, dest
  end

  def convert_lines
    input_and_output_files.each do |unconverted_file_path|
      to_converted = Tempfile.new('temp')

      DosToUnixLines.new(unconverted_file_path, to_converted.path).call
      IO.copy_stream(to_converted.path, unconverted_file_path)
      to_converted.close   
    end
  end

  def create_test_dir
    FileUtils.mkdir_p(problem.tests_dir)
  end

  def is_zip?
    uploaded_file.original_filename.end_with?("zip")
  end

  def input_and_output_files
    problem.input_files + problem.output_files
  end

  def path_to_files
    File.join(problem.tests_dir, uploaded_file.original_filename)
  end
end