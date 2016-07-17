describe Problem do
  it { is_expected.to have_one(:problem_stats).dependent(:destroy) }
end
