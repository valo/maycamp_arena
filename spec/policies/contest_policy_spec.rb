describe ContestPolicy do
  let(:contest) { create(:contest) }
  let(:admin) { create(:user, role: User::ADMIN) }
  let(:coach) { create(:user, role: User::COACH) }
  let(:contester) { create(:user, role: User::CONTESTER) }

  [
    :index?, :new?, :create?, :edit?, :update?,
    :destroy?, :show?
  ].each do |action|
    permissions action do
      it "denies access to anonymous users" do
        expect(ContestPolicy).not_to permit(nil, contest)
      end

      it "denies access to contesters" do
        expect(ContestPolicy).not_to permit(contester, contest)
      end

      it "allows access to admins" do
        expect(ContestPolicy).to permit(admin, contest)
      end

      it "allows access to coaches" do
        expect(ContestPolicy).to permit(coach, contest)
      end
    end
  end

  permissions :download_sources? do
    it "denies access to anonymous users" do
      expect(ContestPolicy).not_to permit(nil, contest)
    end

    it "denies access to contesters" do
      expect(ContestPolicy).not_to permit(contester, contest)
    end

    it "allows access to admins" do
      expect(ContestPolicy).to permit(admin, contest)
    end

    it "denies access to coaches" do
      expect(ContestPolicy).not_to permit(coach, contest)
    end
  end
end
