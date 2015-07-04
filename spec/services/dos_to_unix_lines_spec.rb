require 'rails_helper'

describe DosToUnixLines do
  describe "#call" do
    let(:fixture_path) { ActiveSupport::TestCase.fixture_path }
    let(:source) { File.join("#{fixture_path}", "/task_input.in00") }
    let(:destination) { File.join("#{fixture_path}", "/task_input_task.in00") }

    it "converts the new lines" do
      DosToUnixLines.new(source, destination).call
      converted = File.read(destination)
      File.delete(destination)
      expect(converted).not_to include("\r")
    end

  end
end
