require "test/unit"

require File.join(File.dirname(__FILE__), "../test_helper")

class TestTestHelper < Test::Unit::TestCase
  def setup
    [User, ContestResult, Contest].each(&:destroy_all)
  end
  
  def test_calculating_after_first_contest
    contest = Factory(:contest)
    
    results = []
    results << Factory(:contest_result, :contest => contest, :points => rand * 300) while results.length < 10
    
    changes = RatingCalculation.generate_rating_changes(results)
    
    results = results.sort_by(&:points)
    changes = changes.sort_by(&:rating)
    
    results.each_with_index do |res, i|
      assert res.user == changes[i].user
    end
  end
  
  def test_calculating_the_rating_of_2_coders
    contest = Factory(:contest)
    
    results = []
    results << Factory(:contest_result, :contest => contest, :points => 900)
    results << Factory(:contest_result, :contest => contest, :points => 1300)
    
    changes = RatingCalculation.generate_rating_changes(results)
    
    assert changes[0].rating < changes[1].rating
  end
  
  def test_calculating_the_rating_of_2_tied_coders
    contest = Factory(:contest)
    
    results = []
    results << Factory(:contest_result, :contest => contest, :points => 1300)
    results << Factory(:contest_result, :contest => contest, :points => 1300)
    
    changes = RatingCalculation.generate_rating_changes(results)
    
    assert_equal changes[0].rating, changes[1].rating
  end
  
  def test_calculating_the_rating_of_9_tied_coders
    contest = Factory(:contest)
    
    results = []
    results << Factory(:contest_result, :contest => contest, :points => 1300) while results.length < 9
    
    changes = RatingCalculation.generate_rating_changes(results)
    
    changes.each do |c|
      assert_equal c.rating, changes[0].rating
    end
  end
  
  def test_calculating_the_rating_of_2_coders
    contest = Factory(:contest)

    user1 = Factory(:user)
    user2 = Factory(:user)
    
    user1.rating_changes.create!(:rating => 2200, :volatility => 500)
    user2.rating_changes.create!(:rating => 1900, :volatility => 400)
    
    results = []
    results << Factory(:contest_result, :user => user1, :contest => contest, :points => 150)
    results << Factory(:contest_result, :user => user2, :contest => contest, :points => 300)
    
    changes = RatingCalculation.generate_rating_changes(results)
    changes.each(&:save!)
    
    assert user1.rating_changes(true).last.rating < user2.rating_changes(true).last.rating
  end
  
  def test_calculating_strong_coder_with_leak_result
    contest = Factory(:contest)

    user1 = Factory(:user)
    user2 = Factory(:user)
    
    user1.rating_changes.create!(:rating => 1200, :volatility => 515)
    user2.rating_changes.create!(:rating => 800, :volatility => 515)
    
    results = []
    results << Factory(:contest_result, :user => user1, :contest => contest, :points => 150)
    results << Factory(:contest_result, :user => user2, :contest => contest, :points => 300)
  
    changes = RatingCalculation.generate_rating_changes(results)
    changes.each(&:save!)
    
    changes.each do |ch|
      assert ch.contest_result
    end
    
    assert user1.rating_changes(true).last.rating < user2.rating_changes(true).last.rating
  end
  
  # def test_calculating_strong_coder_with_leak_result
  #   contest = Factory(:contest)
  # 
  #   users = []
  #   users << Factory(:user) while users.length < 50
  #   
  #   norm = Rubystats::NormalDistribution.new
  #   
  #   30.times do |i|
  #     results = []
  #     
  #     users.each_with_index do |user, index|
  #       results << Factory(:contest_result, :user => users[index], :contest => contest, :points => norm.rng * 300)
  #     end
  #     
  #     results[0].points = 350 unless i % 3 == 0
  # 
  #     changes = RatingCalculation.generate_rating_changes(results)
  #     changes.each(&:save!)
  #     
  #     puts [users[0].rating_changes(true).last.rating.to_s, users[0].rating_changes(true).last.volatility.to_s].inspect
  #   end
    
    # users.each do |user|
    #   puts user.rating_changes(true).last.rating
    # end
  # end
end