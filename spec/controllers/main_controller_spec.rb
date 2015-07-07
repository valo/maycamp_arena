describe Admin::MainController do 

  context "with admin user log-in" do
    before { sign_in(user) }
    let(:user) { create(:user, role: User::ADMIN) }

    describe "#results" do
      let(:contest) { create(:contest, start_time: 2.days.ago, end_time: 1.day.ago, results_visible: false) }

      before do
        get :results, contest_id: contest.id
      end
      
      it { is_expected.to respond_with(:success) }
    end

  end

  context "with normal user log-in" do
  	describe "#results with non-visible results" do
      let(:contest) { create(:contest, start_time: 2.days.ago, end_time: 1.day.ago, results_visible: false) }

  	  before do
        get :results, contest_id: contest.id
      end
      
      it { is_expected.to redirect_to(root_path) }
  	end

    describe "#results with visible results" do
      let(:contest) { create(:contest, start_time: 2.days.ago, end_time: 1.day.ago, results_visible: true) }

      before do
        get :results, contest_id: contest.id
      end
      
      it { is_expected.to respond_with(:success) }
    end
    
  end

  describe "#index" do
    it "should assign upcoming contest" do
      contest = create(:contest, start_time: 1.day.from_now, end_time: 2.days.from_now)
      get :index
      expect(assigns(:upcoming_contests)).to eq([contest])
    end
  end

end
