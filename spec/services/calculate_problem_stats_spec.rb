describe CalculateProblemStats do
  let(:user) { create(:user) }
  let(:problem) { create(:problem) }
  let(:calculate_problem_stats) { CalculateProblemStats.new(problem) }

  describe '#call' do
    it 'calculates the stats when there are no run for the problem' do
      calculate_problem_stats.call

      expect(problem.problem_stats.percent_success).to be_zero
    end

    it 'calculates the stats when there is one run with 50% success' do
      create(:run, problem: problem, status: "wa ok")

      calculate_problem_stats.call

      expect(problem.problem_stats.percent_success).to eq(50)
    end

    it 'calculates the stats when there are several runs' do
      create(:run, problem: problem, status: "wa ok")
      create(:run, problem: problem, status: "ok ok")
      create(:run, problem: problem, status: "ok wa")
      create(:run, problem: problem, status: "wa wa")

      calculate_problem_stats.call

      expect(problem.problem_stats.percent_success).to eq(50)
    end

    it 'takes only the best run for each user' do
      create(:run, problem: problem, status: "wa ok", user: user)
      create(:run, problem: problem, status: "ok ok", user: user)

      calculate_problem_stats.call

      expect(problem.problem_stats.percent_success).to eq(100)
    end
  end
end
