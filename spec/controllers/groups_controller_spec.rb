describe GroupsController do
  describe '#show' do
    let(:contest) { create(:contest) }
    let(:group) { contest.group }

    context "without a signed in user" do
      before do
        get :show, id: group.id
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    context "with a signed in user" do
      let(:user) { create(:user) }
      before do
        sign_in user

        get :show, id: group.id
      end

      it { is_expected.to respond_with(:success) }
    end
  end
end
