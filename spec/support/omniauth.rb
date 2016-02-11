module OmniauthHelpers
  def mock_omniauth(provider, mocked_data, is_success: true)
    if is_success
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(mocked_data)
    else
      OmniAuth.config.mock_auth[provider] = mocked_data.to_sym
    end

    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  end
end

OmniAuth.config.test_mode = true

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

RSpec.configure do |config|
  config.include OmniauthHelpers
end
