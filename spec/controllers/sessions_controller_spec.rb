describe SessionsController do
  let!(:user) { create(:user, email: 'em@il.com') }

  describe '#facebook' do
    let(:successful_response) { { provider: :facebook, info: { email: 'em@il.com' } } }
    let(:failure_response) { :error }

    it 'logs user via facebook by email' do
      mock_omniauth(:facebook, successful_response)

      get :facebook

      expect(session[:user_id]).to eq(user.id)
    end
  end
end
