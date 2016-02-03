describe ContestDecorator do
  let(:contest) { create(:contest) }
  let(:contest_decorator) { ContestDecorator.new(contest) }
  let(:user) { create(:user) }
  let(:helpers) { double("Helpers", current_user: user) }

  before do
    allow(contest_decorator).to receive(:h).and_return(helpers)
  end

  describe '#best_practice_score' do
    it "return 0 if there are no runs for the contest" do
      expect(contest_decorator.best_practice_score).to be_zero
    end

    it "return 100 if all the problems are solved" do
      problem = create(:problem, contest: contest)
      run = create(:run, problem: problem, user: user)
      run.update_columns(total_points: 100)

      expect(contest_decorator.best_practice_score).to eq(100)
    end

    it "return 50 if there is a bad solution and a solution with half the points" do
      problem = create(:problem, contest: contest)
      create(:run, problem: problem, user: user)
      run = create(:run, problem: problem, user: user)
      run.update_columns(total_points: 50)

      expect(contest_decorator.best_practice_score).to eq(50)
    end
  end

  describe '#practice_score_percent' do
    it "return 0 if there are no runs for the contest" do
      expect(contest_decorator.practice_score_percent).to be_zero
    end

    it "return 100 if all the problems are solved" do
      problem = create(:problem, contest: contest)
      run = create(:run, problem: problem, user: user)
      run.update_columns(total_points: 100)

      expect(contest_decorator.practice_score_percent).to eq(100)
    end

    it "return 25% if there is an unsolved problem and a half solved problem" do
      create(:problem, contest: contest)
      problem = create(:problem, contest: contest)
      create(:run, problem: problem, user: user)
      run = create(:run, problem: problem, user: user)
      run.update_columns(total_points: 50)

      expect(contest_decorator.practice_score_percent).to eq(25)
    end
  end
end
