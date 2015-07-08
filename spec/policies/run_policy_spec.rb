describe RunPolicy do
  let(:run) { create(:run) }
  
  let(:problem_true) { create(:problem, runs_visible: true) }
  let(:problem_false) { create(:problem, runs_visible: false) }

  let(:false_checkbox_run) { create(:run, problem: problem_false) }
  let(:true_checkbox_run) { create(:run, problem: problem_true) }

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
      expect(RunPolicy).to permit(contester, true_checkbox_run)
    end

    it "denies access to contesters if the run is not visible for them" do
      expect(RunPolicy).not_to permit(contester, false_checkbox_run)
    end

    it "allows access to admins independently" do
      expect(RunPolicy).to permit(admin, false_checkbox_run)
      expect(RunPolicy).to permit(admin, true_checkbox_run)
    end

    it "allows access to coaches if they created the run or if it's visible to them" do
      expect(RunPolicy).to permit(coach, false_checkbox_run) if coach.id == run.user_id
      expect(RunPolicy).to permit(coach, true_checkbox_run)
    end

    it "denies access to coacehs if the didn't created the run and isn't visible to them" do
      expect(RunPolicy).not_to permit(coach, false_checkbox_run) if coach.id != run.user_id
    end

  end


end