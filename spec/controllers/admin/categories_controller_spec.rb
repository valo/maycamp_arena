describe Admin::CategoriesController do
  context "without a logged-in user" do
    describe "#index" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  shared_examples "accessed by authorized user" do
    before { sign_in(user) }

    describe "#index" do
      before { get :index }

      it { is_expected.to respond_with(:success) }
    end

    describe "#new" do
      before { get :new }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:category_params) { attributes_for(:category) }
      before { post :create, params: { category: category_params } }

      it { is_expected.to redirect_to(admin_categories_path) }
    end

    describe "#edit" do
      let(:category) { create(:category) }
      before { get :edit, params: { id: category.id } }

      it { is_expected.to respond_with(:success) }
    end

    describe "#update" do
      let(:category) { create(:category) }
      let(:new_name) { "test test test" }
      before { put :update, params: { id: category.id, category: { name: new_name } } }

      it { is_expected.to redirect_to(admin_categories_path) }

      it "changes the name of the category" do
        expect(category.reload.name).to eq(new_name)
      end
    end

    describe "#destroy" do
      let(:category) { create(:category) }
      before { delete :destroy, params: { id: category.id } }

      it { is_expected.to redirect_to(admin_categories_path) }

      it "deletes the category" do
        expect(Contest.find_by_id(category.id)).to be_nil
      end
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
