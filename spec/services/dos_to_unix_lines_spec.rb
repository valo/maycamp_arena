require 'rails_helper'

describe DosToUnixLines do
  describe "#call" do
    let(:global) { ActiveSupport::TestCase.fixture_path }
    let(:source) { File.join("#{global}", "/path1") }
    let(:destination) { File.join("#{global}", "/path2") }

    it "converts the new lines" do
      some = DosToUnixLines.new(source, destination).call
      converted = File.read(destination)
      expect(converted).not_to include("\r\n")
    end
    
  end
end
