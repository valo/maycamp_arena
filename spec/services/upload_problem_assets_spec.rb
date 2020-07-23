describe UploadProblemAssets do
  let(:problem) { create(:problem) }
  let(:file_zip) { fixture_file_upload(file_fixture("archive.zip")) }
  let(:file_in) { fixture_file_upload(file_fixture("task_input.in00")) }

  it "creates assets for all uploaded files" do
    ProcessUploadedFile.new(file_zip, problem).extract

    expect(problem.all_files.length).to be > 0

    UploadProblemAssets.new(problem).call

    expect(problem.assets.count).to eq(problem.all_files.count)

    expect(problem.assets_blobs.map(&:filename).sort + ["test"]).to eq(problem.all_files.map { |file| File.basename(file) }.sort)
  end

  it "is idempotent" do
    ProcessUploadedFile.new(file_in, problem).extract

    expect(problem.all_files.length).to eq(1)

    UploadProblemAssets.new(problem).call

    expect(problem.assets.count).to eq(1)

    UploadProblemAssets.new(problem).call

    expect(problem.assets.reload.count).to eq(1)
  end
end