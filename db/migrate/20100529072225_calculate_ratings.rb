class CalculateRatings < ActiveRecord::Migration
  def self.up
    RatingChange.transaction do
      Contest.find_each do |contest|
        rating_changes = RatingCalculation.generate_rating_changes(contest.contest_results.to_a)
        rating_changes.each(&:save!)
      end
    end
  end

  def self.down
    RatingChange.destroy_all
  end
end
