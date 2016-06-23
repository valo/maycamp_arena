require 'rating_calculation'

class RatingChange < ActiveRecord::Base
  belongs_to :contest_result, :polymorphic => true
  belongs_to :user
  belongs_to :previous_rating_change, :class_name => "RatingChange"

  validates_presence_of :user

  DEFAULT_INITIAL_RATING = 1200
  DEFAULT_INITIAL_VOLATILITY = 515

  def previous_rating
    previous_rating_change.rating
  end

  def contest
    contest_result.andand.contest
  end

  def change
    self.rating - previous_rating_change.rating
  end

  def rating_color
    self.class.color_from_rating(self.rating)
  end

  def self.color_from_rating(rating)
    if rating >= 2000
      "#FF0000"
    elsif rating >= 1500
      "#CBDD00"
    elsif rating >= 1200
      "#0000FF"
    elsif rating >= 900
      "#00FF00"
    else
      "#CCCCCC"
    end
  end

  def self.regenerate_ratings
    RatingChange.destroy_all

    RatingChange.transaction do
      Contest.map!(&:all).flatten!.sort! { |a,b| a.end_time <=> b.end_time }.each do |contest|
        # Recreate the contest results for the contest
        if contest.instance_of?(Contest)
          contest.contest_results.destroy_all
          contest.generate_contest_results.each do |res|
            contest.contest_results.create!(:user => res.second, :points => res.last)
          end
        end

        rating_changes = RatingCalculation.generate_rating_changes(contest.contest_results.select(&:user))
        rating_changes.each(&:save!)
      end
    end
  end
end
