describe RunPolicy do
  let(:run) { create(:run) }
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

    it "allows access to contesters if the run is visible for them" do
      expect(RunPolicy).to permit(contester, run) if run.problem.runs_visible
    end

    it "allows access to admins" do
      expect(RunPolicy).to permit(admin, run)
    end

    it "allows access to coaches if they created the run or if it's visible to them" do
      expect(RunPolicy).to permit(admin, run) if run.problem.runs_visible || coach.id == run.user_id
    end

  end


end