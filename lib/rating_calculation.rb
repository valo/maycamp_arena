class RatingCalculation
  def self.sqr(x)
    x * x
  end
  
  def self.abs(x)
    x > 0 ? x : -x
  end
  
  def self.sgn(x)
    x > 0 ? 1 : (x < 0 ? -1 : 0)
  end
  
  def self.generate_rating_changes(contest_results)
    return [] if contest_results.length <= 1
    result_ratings = []
    
    norm = Rubystats::NormalDistribution.new
    
    ratings = contest_results.map { |r| r.user.current_rating }
    num_coders = ratings.length
    avg_rating = ratings.map(&:rating).sum(0.0) / num_coders
    
    competition_factor = Math.sqrt(
                            ratings.map { |r| sqr(r.volatility) }.sum / num_coders +
                            ratings.map { |r| sqr(r.rating - avg_rating)}.sum / (num_coders - 1) 
                         )
                         
    contest_results = contest_results.sort_by(&:points).reverse!
    
    ratings.each do |rating1|
      est_rank = 0.5
      ratings.each do |rating2|
        next if rating1 == rating2
        
        win_prob_arg = (rating2.rating - rating1.rating) /
                       Math.sqrt(2 * (sqr(rating1.volatility) + sqr(rating1.volatility)))
        
        # Calculate the probability that the first coder will beat the second
        # coder. This depends on the difference of the 2 coder's ratings and
        # their volatility, but it is a normally distributed random variable.
        # If both coders have equal stats the probability is 0.5. Otherwise the
        # coder with better stats will have higher probability of winning
        est_rank += (Math.erf(win_prob_arg) + 1) / 2
      end
      
      # Calculate the probable performance of the coder. This is the probability
      # he will be on the estimated place. We assume that the probability for
      # being on a given place is with normal distribution
      est_perf = -norm.icdf((est_rank - 0.5) / num_coders)
      
      current_user_result = contest_results.detect { |r| r.user == rating1.user }
      tied_coders = contest_results.count { |res| res.points == current_user_result.points }
      actual_rank = contest_results.count { |res| res.points > current_user_result.points} + (tied_coders + 1) / 2
      actual_perf = -norm.icdf((actual_rank - 0.5) / num_coders)
      
      perf_by_rating = rating1.rating + competition_factor * (actual_perf - est_perf)
      
      weigth = 1.0 / (1 - (0.42 / (rating1.user.times_rated + 1) + 0.18)) - 1
      
      weigth *= 0.9 if rating1.rating >= 2000 and rating1.rating < 2500
      weigth *= 0.8 if rating1.rating >= 2500
      
      cap = 150 + 1500.0 / (rating1.user.times_rated + 2)
      
      delta = competition_factor * weigth / (weigth + 1) * (actual_perf - est_perf)
      delta = cap if delta > cap
      delta = -cap if delta < -cap
      
      new_rating = rating1.rating + delta
      
      new_volatility = Math.sqrt(sqr(new_rating - rating1.rating) / weigth +
                                 sqr(rating1.volatility) / (weigth + 1))
      
      result_ratings << RatingChange.new(:user => rating1.user,
                                         :volatility => new_volatility,
                                         :rating => new_rating,
                                         :contest_result => current_user_result,
                                         :previous_rating_change => current_user_result.user.current_rating)
    end
    
    result_ratings
  end
end