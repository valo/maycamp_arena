class UploadProblemAssets
  def initialize(problem)
    @problem = problem
  end

  def call
    @problem.all_files.each do |file|
      next if @problem.assets_blobs.any? { |blob| blob.filename == File.basename(file) }

      @problem.assets.attach(io: File.open(file), filename: File.basename(file))
    end
  end
end