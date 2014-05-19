require File.dirname(__FILE__) + '/../test_helper'
require 'active_support/core_ext/string/output_safety'

class RunTest < ActiveSupport::TestCase
  
  test "creating a run with invalid UTF-8 characters" do
    u = FactoryGirl.create(:user)
    r = FactoryGirl.build(:run, :user => u, :source_code => "hello joel\255")

    assert r.save, r.errors.messages
    assert_equal ERB::Util.html_escape(r.source_code), "hello joel"
  end
end
