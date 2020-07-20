describe UsersController do

  shared_examples "accessed by unauthorized user" do
    before { sign_in(current_user) if current_user }

    describe "#edit" do
      let(:user) { create(:user) }
      before { get :edit, params: { id: user.id } }

      it { is_expected.to redirect_to(new_session_path) }
    end

  end

  shared_examples "accessed by authorized user" do
    before { sign_in(current_user) }

    describe "#new" do
      before { get :new }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:user_params) { attributes_for(:user) }
      before { post :create, params: { user: user_params } }

      it { is_expected.to redirect_to(root_path) }
    end

    describe "#edit" do
      let(:user) { create(:user) }
      before { get :edit, params: { id: user.id } }

      it { is_expected.to respond_with(:success) }
    end
  end


  context "without a logged-in user" do
    let(:current_user) { nil }

    it_behaves_like "accessed by unauthorized user"
  end

  context "with an contester user" do
    let(:current_user) { create(:user, role: User::CONTESTER) }

    it_behaves_like "accessed by authorized user"
  end
end

