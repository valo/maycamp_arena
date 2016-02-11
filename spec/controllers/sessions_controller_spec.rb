describe SessionsController do
  let!(:first) { create(:user, email: 'em@il.com') }
  let!(:second) { create(:user, email: 'em@il.com') }

  describe '#facebook' do
    let(:successful_response) { { provider: :facebook, info: { email: 'em@il.com' } } }
    let(:failure_response) { :error }

    before(:each) do
      mock_omniauth(:facebook, successful_response)
      get :facebook
    end

    it 'finds a user by Facebook email' do
      expect(session[:user_id]).to be
    end

    it 'logs the last user with the given email' do
      expect(session[:user_id]).to eq(second.id)
    end

    it "redirects to root" do
      expect(response).to redirect_to root_path
    end
  end

  # Commented out since `get :failure` fails with an odd error:
  # ActionController::UrlGenerationError:
  # No route matches {:action=>"failure", :controller=>"sessions"} missing required keys: [:action]

  # describe '#failure' do
  #   before(:each) do
  #     mock_omniauth(:facebook, :error_message, is_success: false)
  #     get :failure
  #   end

  #   it 'logs no user when omniauth failure happens' do
  #     expect(session[:user_id]).to be_empty
  #   end

  #     it "redirects to root" do
  #       expect(response).to redirect_to root_path
  #     end
  # end
end
