describe RunPolicy do
  let(:run) { create(:run) }
  let(:coach_run) { create(:run, user_id: coach.id, problem: coach_problem) }

  let(:problem_with_visible_runs) { create(:problem, runs_visible: true) }
  let(:problem_without_visible_runs) { create(:problem, runs_visible: false) }
  let(:coach_problem) { create(:problem, runs_visible: false) }

  let(:private_run) { create(:run, problem: problem_without_visible_runs) }
  let(:public_run) { create(:run, problem: problem_with_visible_runs) }

  let(:admin) { create(:user, role: User::ADMIN) }
  let(:coach) { create(:user, role: User::COACH) }
  let(:contester) { create(:user, role: User::CONTESTER) }

  [
    :index?, :create?, :queue?, :new?
  ].each do |action|
    permissions action do

      it "denies access to anonymous users" do
        expect(RunPolicy).not_to permit(nil, run)
      end

      it "denies access to contesters" do
        expect(RunPolicy).not_to permit(contester, run)
      end

      it "allows access to admins" do
        expect(RunPolicy).to permit(admin, run)
      end

      it "allows access to coaches" do
        expect(RunPolicy).to permit(coach, run)
      end

    end
  end

  [
    :update?, :edit?
  ].each do |action|
    permissions action do

      it "denies access to anonymous users" do
        expect(RunPolicy).not_to permit(nil, run)
      end

      it "denies access to contesters" do
        expect(RunPolicy).not_to permit(contester, run)
      end

      it "allows access to admins" do
        expect(RunPolicy).to permit(admin, run)
      end

      it "denies access to coaches" do
        expect(RunPolicy).not_to permit(coach, run)
      end

    end
  end

  permissions :show? do
    it "denies access to anonymous users" do
      expect(RunPolicy).not_to permit(nil, run)
    end

    it "denies access to contesters if the run is visible for them" do
      expect(RunPolicy).not_to permit(contester, public_run)
    end

    it "denies access to contesters if the run is not visible for them" do
      expect(RunPolicy).not_to permit(contester, private_run)
    end

    it "allows access to admins independently" do
      expect(RunPolicy).to permit(admin, private_run)
      expect(RunPolicy).to permit(admin, public_run)
    end

    it "allows access to coaches if they created the run or if it's visible to them" do
      expect(RunPolicy).to permit(coach, coach_run)
      expect(RunPolicy).not_to permit(coach, public_run)
    end

    it "denies access to coaches if the didn't created the run and isn't visible to them" do
      expect(RunPolicy).not_to permit(coach, private_run)
    end
  end
end
