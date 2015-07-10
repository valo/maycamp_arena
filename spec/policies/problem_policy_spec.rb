describe ContestPolicy do
  let(:problem) { create(:problem) }
  let(:admin) { create(:user, role: User::ADMIN) }
  let(:coach) { create(:user, role: User::COACH) }
  let(:contester) { create(:user, role: User::CONTESTER) }

  permissions :toggle_runs_visible? do
    it "denies access to anonymous users" do
      expect(ProblemPolicy).not_to permit(nil, problem)
    end

    it "denies access to contesters" do
      expect(ProblemPolicy).not_to permit(contester, problem)
    end

    it "allows access to admins" do
      expect(ProblemPolicy).to permit(admin, problem)
    end

    it "denies access to coaches" do
      expect(ProblemPolicy).not_to permit(coach, problem)
    end
  end

end
