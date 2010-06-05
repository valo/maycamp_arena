class GenerateContestResults < ActiveRecord::Migration
  def self.up
    ContestResult.transaction do
      Contest.finished.find_each do |contest|
        contest.generate_contest_results.each do |res|
          ContestResult.create!(:user => res.second, :contest => contest, :points => res.last)
        end
      end
    end
  end

  def self.down
    ContestResult.destroy_all
  end
end
