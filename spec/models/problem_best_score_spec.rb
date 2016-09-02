describe ProblemBestScore do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:problem) }
end
