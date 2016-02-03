describe User do
  let(:user) { create(:user) }
  describe '#full_tasks' do
    it "should return zero if there are no runs" do
      expect(user.full_tasks).to be_zero
    end

    it "should return there is one task with full points" do
      create(:run, user: user, status: "ok wa wa wa wa")
      run_with_points = create(:run, user: user, status: "ok ok ok ok ok")
      create(:run, user: user, status: "ok ok ok ok ok", problem: run_with_points.problem)

      expect(user.full_tasks).to eq(1)
    end
  end
end
