describe IncreaseExpForUserJob do
  let(:user) { create(:user) }
  let(:gained_exp) { 10 }
  let(:increase_exp_for_user) { instance_double(IncreaseExpForUser) }

  it 'calls the IncreaseExpForUser service object' do
    expect(IncreaseExpForUser).to receive(:new).with(user, gained_exp).and_return(increase_exp_for_user)
    expect(increase_exp_for_user).to receive(:call)

    IncreaseExpForUserJob.perform_now(user.id, gained_exp)
  end
end
