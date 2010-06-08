class Admin::RatingsController < Admin::BaseController
  def recalculate
    RatingChange.destroy_all
    RatingChange.regenerate_ratings
    
    redirect_to :back
  end
end