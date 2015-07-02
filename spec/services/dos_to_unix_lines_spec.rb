require 'rails_helper'

describe DosToUnixLines do
	describe "#call" do
		global = ActiveSupport::TestCase.fixture_path
		first_path = File.join("#{global}", "/path1")
		second_path = File.join("#{global}", "/path2")
		let(:some) { DosToUnixLines.new(first_path, second_path).call }

		it "converts the new lines" do
			converted = File.read(second_path)
			expect(converted).not_to include("\r\n")
		end
	end
end
