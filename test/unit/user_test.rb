require 'test_helper'
class UserTest < ActiveSupport::TestCase
  
  test "the truth" do
    assert true
  end
  
  test "user is contester by default" do
    user = User.new
    assert user.contester?
  end
    
  test "only non admin contester can compete" do
    user = User.new
    assert user.participates_in_contests?
    user.admin = 1
    assert (not user.participates_in_contests?)
    user.contester = 0
    assert (not user.participates_in_contests?)
    user.admin = 0
    assert (not user.participates_in_contests?)
  end
end
