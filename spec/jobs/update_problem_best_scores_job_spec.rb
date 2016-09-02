describe UpdateProblemBestScoresJob do
  let(:user) { create(:user) }
  let(:update_problem_best_scores) { instance_double(UpdateProblemBestScores) }

  it 'calls the UpdateProblemBestScores service object' do
    expect(UpdateProblemBestScores).to receive(:new).with(user).and_return(update_problem_best_scores)
    expect(update_problem_best_scores).to receive(:call)

    UpdateProblemBestScoresJob.perform_now(user.id)
  end
end
