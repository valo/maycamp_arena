require File.dirname(__FILE__) + '/../../spec_helper'

module Admin
  describe ContestsController do
    before do
      @contest = Contest.create!(:name => "Fall contest", 
                                 :duration => 0,
                                 :start_time => Time.now,
                                 :end_time => Time.now)
      @admin = User.new(:login => "root",
                        :city => "Sofia",
                        :name => "Admin",
                        :email => "admin@example.com")
      @admin.unencrypted_password = "123123"
      @admin.unencrypted_password_confirmation = "123123"
      @admin.admin = true
      @admin.save!
      request.session[:user_id] = @admin.id
    end

    it "should be able to destroy contests" do
      delete :destroy, :id => @contest.id
      
      Contest.find_by_id(@contest.id).should be_nil
    end
  end
end