require 'rails_helper'

describe DosToUnixLines do
  describe "#call" do
    let(:source) { file_fixture("task_input.in00") }
    let(:destination) { source.dirname + "task_input_task.in00" }

    it "converts the new lines" do
      DosToUnixLines.new(source.to_path, destination.to_path).call
      converted = destination.read
      destination.delete
      expect(converted).not_to include("\r")
    end

  end
end
