describe Admin::GroupsController do
  let(:group) { create(:group) }
  let(:group_attributes) { attributes_for(:group) }

  context "when there is not authorized user" do
    describe '#index' do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe '#new' do
      before do
        get :new
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe '#create' do
      before do
        post :create
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe '#edit' do
      before do
        get :edit, params: { id: group.id }
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe '#update' do
      let(:group) { create(:group) }

      before do
        put :update, params: { id: group.id, group: group_attributes }
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe '#destroy' do
      let(:group) { create(:group) }

      before do
        delete :destroy, params: { id: group.id }
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  context "when there is an authorized user" do
    let(:admin_user) { create(:user, :admin) }

    before do
      sign_in(admin_user)
    end

    describe '#index' do
      before do
        get :index
      end

      it { is_expected.to respond_with(:success) }
    end

    describe '#new' do
      before do
        get :new
      end

      it { is_expected.to respond_with(:success) }
    end

    describe '#create' do
      before do
        post :create, params: { group: group_attributes }
      end

      it { is_expected.to redirect_to(admin_groups_path) }
    end

    describe '#edit' do
      before do
        get :edit, params: { id: group.id }
      end

      it { is_expected.to respond_with(:success) }
    end

    describe '#update' do
      let(:group) { create(:group) }

      before do
        put :update, params: { id: group.id, group: group_attributes }
      end

      it { is_expected.to redirect_to(admin_groups_path) }
    end

    describe '#destroy' do
      let(:group) { create(:group) }

      before do
        delete :destroy, params: { id: group.id }
      end

      it { is_expected.to redirect_to(admin_groups_path) }
    end
  end
end
