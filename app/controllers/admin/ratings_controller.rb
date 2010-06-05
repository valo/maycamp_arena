class Admin::RatingsController < Admin::BaseController
  def recalculate
    RatingChange.regenerate_ratings
    
    redirect_to :back
  end
end