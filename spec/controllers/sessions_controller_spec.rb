require 'rails_helper'
require 'pry'

RSpec.describe SessionsController, type: :controller do

  context 'with user' do
    describe 'login' do

      it 'set devise encryption and empty old password field' do
        u = User.create(
          login: "Valentin Mihov 123",
          name: "login",
          email: "valentin.mihov@gmail.com",
          city: BG_CITIES.first,
          encrypted_password: User.devise_encrypt_password("123")
        )

        u.unencrypted_password = "123"
        u.save!

        login = User.authenticate(u.email, u.password)

        expect( login.password ).to eq nil
      end
    end
  end
end
