describe Admin::UsersController do
  shared_examples "accessed by unauthorized user" do
    before { sign_in(current_user) if current_user }

    describe "#index" do
      before { get :index }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#new" do
      before { get :new }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#create" do
      let(:user_params) { attributes_for(:user) }
      before { post :create, user: user_params }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#edit" do
      let(:user) { create(:user) }
      before { get :edit, id: user.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#update" do
      let(:user) { create(:user) }
      let(:new_name) { "test test test" }
      before { put :update, id: user.id, user: { name: new_name } }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#restart_time" do
      let(:user) { create(:user) }
      before { get :restart_time, id: user.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#destroy" do
      let(:user) { create(:user) }
      before { delete :destroy, id: user.id }

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  shared_examples "accessed by authorized user" do
    before { sign_in(current_user) }

    describe "#index" do
      before { get :index }

      it { is_expected.to respond_with(:success) }
    end

    describe "#new" do
      before { get :new }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:user_params) { attributes_for(:user) }
      before { post :create, user: user_params }

      it { is_expected.to redirect_to(admin_users_path) }
    end

    describe "#edit" do
      let(:user) { create(:user) }
      before { get :edit, id: user.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#update" do
      let(:user) { create(:user) }
      let(:new_name) { "test test test" }
      before { put :update, id: user.id, user: { name: new_name } }

      it { is_expected.to redirect_to(admin_users_path) }

      it "changes the name of the user" do
        expect(user.reload.name).to eq(new_name)
      end
    end

    describe "#destroy" do
      let(:user) { create(:user) }
      before { delete :destroy, id: user.id }

      it { is_expected.to redirect_to(admin_users_path) }

      it "deletes the user" do
        expect(Contest.find_by_id(user.id)).to be_nil
      end
    end

    describe "#restart_time" do
      let(:user) { create(:user) }
      let(:contest) { create(:contest) }
      before { get :restart_time, id: user.id, contest_id: contest.id }

      it { is_expected.to redirect_to(admin_user_path(user)) }
    end
  end

  context "without a logged-in user" do
    let(:current_user) { nil }

    it_behaves_like "accessed by unauthorized user"
  end

  context "with an admin user" do
    let(:current_user) { create(:user, role: User::ADMIN) }

    it_behaves_like "accessed by authorized user"
  end


  context "with a coach user" do
    let(:current_user) { create(:user, role: User::COACH) }

    it_behaves_like "accessed by unauthorized user"
  end
end
