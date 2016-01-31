describe GroupDecorator do
  let(:group) { create(:group) }
  let(:group_decorator) { GroupDecorator.new(group) }
  let(:user) { create(:user) }
  let(:contest) { create(:contest, group: group) }
  let(:problem) { create(:problem, contest: contest) }
  let(:contests_decorator) { [instance_double(ContestDecorator)] }
  let(:helpers) { double("Helpers", current_user: user) }

  before do
    expect(group_decorator).to receive(:contests).and_return(contests_decorator)
  end

  describe "#best_practice_score" do
    it "return 0 if there are no contests with score" do
      expect(contests_decorator.first).to receive(:best_practice_score).and_return(0)

      expect(group_decorator.best_practice_score).to be_zero
    end

    it "return 100 if there is a contest with 100 scrore" do
      expect(contests_decorator.first).to receive(:best_practice_score).and_return(100)

      expect(group_decorator.best_practice_score).to eq(100)
    end
  end

  describe "#practice_score_percent" do
    it "return 0 if there are no contests for the group" do
      expect(contests_decorator.first).to receive(:practice_score_percent).and_return(0)

      expect(group_decorator.practice_score_percent).to be_zero
    end

    it "return 100 if there is a contest with 100 points" do
      expect(contests_decorator.first).to receive(:practice_score_percent).and_return(100)

      expect(group_decorator.practice_score_percent).to eq(100)
    end
  end

  describe "#max_score" do
    let(:contests_decorator) { [instance_double(Contest)] }

    it "return 0 if there are no contests for the group" do
      expect(contests_decorator.first).to receive(:max_score).and_return(0)

      expect(group_decorator.max_score).to be_zero
    end

    it "return 100 if there is one contest with 100 points" do
      expect(contests_decorator.first).to receive(:max_score).and_return(100)

      expect(group_decorator.max_score).to eq(100)
    end
  end
end
