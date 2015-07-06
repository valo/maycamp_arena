require 'rails_helper'

include ActionDispatch::TestProcess
describe ProcessUploadedFile do

  after(:all) do
    contest = Contest.new
    filesystem = Problem.new.filesystem_name
    tests_dir = File.join(contest.root_dir, filesystem)   
    tests_dir = File.join(tests_dir, "/*")
    FileUtils.rm_rf(Dir.glob(tests_dir))
  end

  let(:contest) { create(:contest) }
  describe "extract" do
    let(:problem) { create(:problem, contest: contest) }
    let(:file_in) { fixture_file_upload("task_input.in00") }
    let(:file_ans) { fixture_file_upload("test.ans") }
    let(:file_zip) { fixture_file_upload("archive.zip") }

    it "extracts non-zip files and converting new lines to unix format" do
      ProcessUploadedFile.new(file_in, problem).extract
      ProcessUploadedFile.new(file_ans, problem).extract

      expect(File).to exist(problem.input_files.first) 
      expect(File).to exist(problem.output_files.first)  

      expect(File.read(problem.input_files.first)).not_to include("\r")
      expect(File.read(problem.output_files.first)).not_to include("\r")
    end

    it "extracts zip files and converting new lines to unix format" do
      ProcessUploadedFile.new(file_zip, problem).extract
      problem.input_files.each do |file_path|
        converted = File.read(file_path)
        expect(converted).not_to include("\r")
      end
      problem.output_files.each do |file_path|
        converted = File.read(file_path)
        expect(converted).not_to include("\r")
      end
    end

  end
end