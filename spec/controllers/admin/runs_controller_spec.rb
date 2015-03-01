describe Admin::RunsController do
  let(:problem) { create(:problem) }
  let(:contest) { problem.contest }

  shared_examples "accessed by unauthorized user" do
    describe "#index" do
      before { get :index, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#new" do
      before { get :new, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#create" do
      let(:run_params) { attributes_for(:run) }
      before { post :create, contest_id: contest.id, problem_id: problem.id, run: run_params }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#edit" do
      let(:run) { create(:run) }
      before { get :edit, id: run.id, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#update" do
      let(:run) { create(:run) }
      let(:new_source_code) { "test test test" }
      before { put :update, id: run.id, run: { source_code: new_source_code }, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end
  end

  context "without a logged-in user" do
    it_behaves_like "accessed by unauthorized user"
  end

  context "with an admin user" do
    let(:current_user) { create(:user, role: User::ADMIN) }

    before { sign_in(current_user) }

    describe "#index" do
      before { get :index, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:run_params) { attributes_for(:run).merge(user_id: current_user.id) }
      before { post :create, run: run_params, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(admin_contest_problem_runs_path(contest, problem)) }
    end

    describe "#new" do
      before { get :new, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#edit" do
      let(:run) { create(:run) }
      before { get :edit, id: run.id, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#update" do
      let(:run) { create(:run, problem: problem) }
      let(:new_source_code) { "test test test" }
      before { put :update, id: run.id, run: { source_code: new_source_code }, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(admin_contest_problem_run_path(contest, problem, run)) }

      it "changes the source code of the run" do
        expect(Run.find(run.id).source_code).to eq(new_source_code)
      end
    end
  end

  context "with a coach user" do
    let(:current_user) { create(:user, role: User::COACH) }

    before { sign_in(current_user) }

    describe "#index" do
      before { get :index, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to respond_with(:success) }
    end

    describe "#create" do
      let(:run_params) { attributes_for(:run) }
      before { post :create, run: run_params, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#new" do
      before { get :new, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#edit" do
      let(:run) { create(:run) }
      before { get :edit, id: run.id, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end

    describe "#update" do
      let(:run) { create(:run, problem: problem) }
      let(:new_source_code) { "test test test" }
      before { put :update, id: run.id, run: { source_code: new_source_code }, contest_id: contest.id, problem_id: problem.id }

      it { is_expected.to redirect_to(new_session_path) }
    end
  end
end
