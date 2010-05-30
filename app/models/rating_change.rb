class RatingChange < ActiveRecord::Base
  belongs_to :contest_result
  belongs_to :user
  belongs_to :previous_rating_change, :class_name => "RatingChange"
  has_one :contest, :through => :contest_result
  
  validates_presence_of :user
  
  DEFAULT_INITIAL_RATING = 1200
  DEFAULT_INITIAL_VOLATILITY = 515
  
  def previous_rating
    previous_rating_change.rating
  end
  
  def change
    self.rating - previous_rating_change.rating
  end
  
  def rating_color
    if self.rating >= 2000
      "#FF0000"
    elsif self.rating >= 1500
      "#00FF00"
    elsif self.rating >= 1000
      "#0000FF"
    else
      "#CCCCCC"
    end
  end
end
