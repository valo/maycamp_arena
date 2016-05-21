describe TimedContestController do
  describe '#open_contest' do
    let(:user) { create(:user) }

    context 'when there is no user logged in' do
      before do
        get :open_contest
      end

      it { is_expected.to redirect_to(new_session_path) }
    end

    context 'when the contest is not visible' do
      let(:contest) { create(:contest, visible: false) }

      before do
        sign_in user
        get :open_contest, contest_id: contest.id
      end

      it { is_expected.to redirect_to(root_path) }
    end

    context 'when the contest is visible' do
      let(:contest) { create(:contest, visible: true) }

      before do
        sign_in user
        get :open_contest, contest_id: contest.id
      end

      it { is_expected.to respond_with(:success) }

      it 'creates a contest start event' do
        expect(contest.user_open_time(user)).to be_within(1.second).of(Time.current)
      end
    end

    context 'when the contest is opened for the second time' do
      let(:contest) { create(:contest, visible: true) }
      let(:contest_open_time) { 30.minutes.ago }
      let!(:contest_start_event) do
        create(:contest_start_event, user: user, contest: contest, created_at: contest_open_time)
      end

      before do
        sign_in user
        get :open_contest, contest_id: contest.id
      end

      it { is_expected.to respond_with(:success) }

      it 'creates a contest start event' do
        expect(contest.user_open_time(user)).to be_within(1.second).of(contest_open_time)
      end
    end
  end
end
