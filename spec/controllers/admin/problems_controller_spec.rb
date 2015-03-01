describe Admin::ProblemsController do
  let(:contest) { create(:contest) }
  context "without a logged-in user" do
    describe "#index" do
      before do
        get :index, contest_id: contest.id
      end

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  shared_examples "accessed by authorized user" do
    before { sign_in(user) }

    describe "#index" do
      before { get :index, contest_id: contest.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#new" do
      before { get :new, contest_id: contest.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:problem_params) { attributes_for(:problem) }
      before { post :create, contest_id: contest.id, problem: problem_params }

      it { is_expected.to redirect_to(admin_contest_problems_path(contest)) }
    end

    describe "#edit" do
      let(:problem) { create(:problem, contest: contest) }
      before { get :edit, id: problem.id, contest_id: contest.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#update" do
      let(:problem) { create(:problem, contest: contest) }
      let(:new_name) { "test test test" }
      before { put :update, id: problem.id, problem: { name: new_name }, contest_id: contest.id }

      it { is_expected.to redirect_to(admin_contest_problems_path(contest)) }

      it "changes the name of the problem" do
        expect(problem.reload.name).to eq(new_name)
      end
    end

    describe "#destroy" do
      let(:problem) { create(:problem, contest: contest) }
      before { delete :destroy, id: problem.id, contest_id: contest.id }

      it { is_expected.to redirect_to(admin_contest_problems_path(contest)) }

      it "deletes the problem" do
        expect(Contest.find_by_id(problem.id)).to be_nil
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
