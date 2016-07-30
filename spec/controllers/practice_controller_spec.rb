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
end
