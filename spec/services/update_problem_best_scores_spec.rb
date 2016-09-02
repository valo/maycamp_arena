describe UpdateProblemBestScores do
  let(:problem) { create(:problem) }
  let(:user) { create(:user) }
  let(:update_problem_best_scores) { UpdateProblemBestScores.new(user) }
  let(:increase_exp_for_user) { instance_double(IncreaseExpForUser) }

  describe '#call' do
    it 'works when there are not runs for the user' do
      update_problem_best_scores.call
    end

    it 'creates a new best score entry when first run is added for a problem' do
      expect(IncreaseExpForUser).to receive(:new)
        .with(user, IncreaseExpForUser::DEFAULT_PROBLEM_EXP)
        .and_return(increase_exp_for_user)
      expect(increase_exp_for_user).to receive(:call)

      create(:run, user: user, problem: problem, status: "ok")

      # update_problem_best_scores.call

      expect(user.problem_best_scores.find_by(problem_id: problem.id).top_points).to eq(100)
    end

    it 'updates an existing best score entry when a new run is added for a problem' do
      expect(IncreaseExpForUser).to receive(:new)
        .with(user, IncreaseExpForUser::DEFAULT_PROBLEM_EXP / 2)
        .and_return(increase_exp_for_user)

      expect(increase_exp_for_user).to receive(:call)

      create(:run, user: user, problem: problem, status: "wa ok")

      # update_problem_best_scores.call

      expect(user.problem_best_scores.find_by(problem_id: problem.id).top_points).to eq(50)

      expect(IncreaseExpForUser).to receive(:new)
        .with(user, IncreaseExpForUser::DEFAULT_PROBLEM_EXP / 2)
        .and_return(increase_exp_for_user)
      expect(increase_exp_for_user).to receive(:call)

      create(:run, user: user, problem: problem, status: "ok ok")

      # update_problem_best_scores.call

      expect(user.problem_best_scores.find_by(problem_id: problem.id).top_points).to eq(100)
    end
  end
end
