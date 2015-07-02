describe Admin::MainController do 
    describe "#index" do
      it "should assign upcoming contest" do
        contest = create(:contest, start_time: 1.day.from_now, end_time: 2.days.from_now)
        get :index
        expect(assigns(:upcoming_contests)).to eq([contest])
      end
    end
end
