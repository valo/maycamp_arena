require 'test_helper'
class UserTest < ActiveSupport::TestCase
  test "user is contester by default" do
    user = User.new
    assert user.contester?
  end
    
  test "only non admin contester can compete" do
    user = User.new
    assert user.participates_in_contests?
    user.role = User::ADMIN
    assert (not user.participates_in_contests?)
    user.role = User::COACH
    assert (not user.participates_in_contests?)
  end
end
