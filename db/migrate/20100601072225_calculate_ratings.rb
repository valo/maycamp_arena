class CalculateRatings < ActiveRecord::Migration
  def self.up
    RatingChange.regenerate_ratings
  end

  def self.down
    RatingChange.destroy_all
  end
end
