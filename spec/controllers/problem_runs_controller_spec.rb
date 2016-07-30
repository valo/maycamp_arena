describe ProblemRunsController do
  describe '#show' do
    context 'with a non-visible contest' do
      let(:contest) { create(:contest, visible: false) }
      let(:problem) { create(:problem, contest: contest) }

      it 'raises a not found error' do
        expect { get :show, id: problem.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a visible contest' do
      let(:contest) { create(:contest, visible: true, practicable: true) }
      let(:problem) { create(:problem, contest: contest) }

      before do
        get :show, id: problem.id
      end

      it { is_expected.to respond_with(:success) }
    end
  end
end
