require 'rails_helper'

describe Admin::ContestsController do
  context "without a logged-in user" do
    describe "#index" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  shared_examples "accessed by authorized user" do
    describe "#index" do
      before do
        sign_in(user)

        get :index
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  context "with an admin user" do
    let(:user) { create(:user, role: User::ADMIN) }

    it_behaves_like "accessed by authorized user"
  end


  context "with a coach user" do
    let(:user) { create(:user, role: User::COACH) }

    it_behaves_like "accessed by authorized user"
  end
end
