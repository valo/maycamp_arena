describe ProblemsController do
  describe '#index' do
    before do
      get :index
    end

    it { is_expected.to respond_with(:success) }
  end
end
