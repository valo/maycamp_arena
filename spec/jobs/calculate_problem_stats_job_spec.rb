describe CalculateProblemStatsJob do
  let(:problem) { create(:problem) }
  let(:calculate_problem_stats) { instance_double(CalculateProblemStats) }

  it 'calls CalculateProblemStats' do
    expect(CalculateProblemStats).to receive(:new).with(problem).and_return(calculate_problem_stats)
    expect(calculate_problem_stats).to receive(:call)

    CalculateProblemStatsJob.perform_now(problem.id)
  end
end
