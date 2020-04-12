describe Admin::ContestsController do
  context "without a logged-in user" do
    describe "#index" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#download_sources" do
      let(:contest) { create(:contest) }

      before do
        get :download_sources, params: { id: contest.id }
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  shared_examples "accessed by authorized user" do
    describe "#index" do
      before { get :index }

      it { is_expected.to respond_with(:success) }
    end

    describe "#new" do
      before { get :new }

      it { is_expected.to respond_with(:success) }
    end

    describe "#show" do
      let(:contest) { create(:contest) }
      before { get :show, params: { id: contest.id } }

      it { is_expected.to redirect_to(admin_contest_problems_path(contest.id)) }
    end

    describe "#create" do
      let(:group) { create(:group) }
      let(:contest_params) { attributes_for(:contest).merge(group_id: group.id) }

      before do
        post :create, params: { contest: contest_params }
      end

      it { is_expected.to redirect_to(admin_contests_path) }
    end

    describe "#edit" do
      let(:contest) { create(:contest) }
      before { get :edit, params: { id: contest.id } }

      it { is_expected.to respond_with(:success) }
    end

    describe "#update" do
      let(:contest) { create(:contest) }
      let(:new_name) { "test test test" }
      before { put :update, params: { id: contest.id, contest: { name: new_name } } }

      it { is_expected.to redirect_to(edit_admin_contest_path(contest)) }

      it "changes the name of the contest" do
        expect(contest.reload.name).to eq(new_name)
      end
    end

    describe "#destroy" do
      let(:contest) { create(:contest) }
      before { delete :destroy, params: { id: contest.id } }

      it { is_expected.to redirect_to(admin_contests_path) }

      it "deletes the contest" do
        expect(Contest.find_by_id(contest.id)).to be_nil
      end
    end
  end

  context "with an admin user" do
    before { sign_in(user) }

    let(:user) { create(:user, role: User::ADMIN) }

    it_behaves_like "accessed by authorized user"

    describe "#download_sources" do
      let(:contest) { create(:contest) }

      before do
        expect(controller).to receive(:send_file) { controller.head :ok }

        get :download_sources, params: { id: contest.id }
      end

      it { is_expected.to respond_with(:success) }
    end
  end


  context "with a coach user" do
    before { sign_in(user) }

    let(:user) { create(:user, role: User::COACH) }

    it_behaves_like "accessed by authorized user"

    describe "#download_sources" do
      let(:contest) { create(:contest) }

      before do
        get :download_sources, params: { id: contest.id }
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end
end
