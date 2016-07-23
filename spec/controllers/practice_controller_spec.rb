describe PracticeController do
  describe '#open_contest' do
    let(:user) { create(:user) }

    context 'when there is no user logged in' do
      before do
        get :open_contest
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    context 'when the contest is not practicable' do
      let(:contest) { create(:contest, practicable: false) }

      before do
        sign_in user
        get :open_contest, contest_id: contest.id
      end

      it { is_expected.to redirect_to(root_path) }
    end

    context 'when the contest is practicable' do
      let(:contest) { create(:contest, practicable: true) }

      before do
        sign_in user
        get :open_contest, contest_id: contest.id
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  describe '#submit_solution' do
    let(:user) { create(:user) }
    let(:run) { build(:run) }
    let(:run_params) { run.attributes.merge(source_code: 'test') }

    context 'when there is no user logged in' do
      before do
        post :submit_solution
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    context 'when the contest is not practicable' do
      let(:contest) { create(:contest, practicable: false) }

      before do
        sign_in user
        post :submit_solution, contest_id: contest.id
      end

      it { is_expected.to redirect_to(root_path) }
    end

    context 'when the contest is practicable' do
      let(:contest) { create(:contest, practicable: true) }
      let(:problem) { create(:problem, contest: contest) }
      let(:run) { build(:run, problem_id: problem.id) }

      before do
        sign_in user
        post :submit_solution, run: run_params, contest_id: contest.id
      end

      it { is_expected.to redirect_to(action: :open_contest, contest_id: contest.id) }
    end
  end
end
