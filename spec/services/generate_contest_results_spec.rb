require 'rails_helper'

describe GenerateContestResults do
  describe "#call" do
    let(:contest) { create(:contest, start_time: 10.hours.ago, end_time: 5.hours.ago) }
    let(:problem) { create(:problem, contest: contest) }
    let(:user) { create(:user) }
    let(:contest_results) { GenerateContestResults.new(contest).call }

    context "with user with no runs" do
      before do
        create(:contest_start_event, user: user, contest: contest, created_at: 9.hours.ago, updated_at: 9.hours.ago)
      end

      it "has no entries" do
        expect(contest_results).to be_empty
      end
    end

    context "with user with runs during the contest" do
      before do
        create(:contest_start_event, user: user, contest: contest, created_at: contest.start_time, updated_at: contest.start_time)
        create(:run, user: user, problem: problem, created_at: contest.start_time + 1.hour, updated_at: contest.start_time + 1.hour, status: (["ok"] * 8).join(" ") + " wa wa")
      end

      it "has one entry" do
        expect(contest_results.length).to be(1)
      end

      it "calculates the total points" do
        expect(contest_results[0].last.to_i).to be(80)
      end
    end
  end
end
