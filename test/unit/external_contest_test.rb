require 'test_helper'

class ExternalContestTest < ActiveSupport::TestCase
  def test_matching_names
    contest = ExternalContest.new
    assert_equal "valio", contest.send(:latinize, "Вальо")
    assert_equal 1, contest.send(:match_names, contest.send(:latinize, "Вальо"), "Valio")
  end
  
  def test_matching_names2
    contest = ExternalContest.new
    assert_equal 2, contest.send(:match_names, contest.send(:latinize, "Калина Христова Петрова"), "Kalina Petrova")
  end
end
