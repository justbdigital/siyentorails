describe Devise::UserOmniauthCallbacksController, :focus do

  context 'success' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      valid_facebook_login_setup
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
    end

    it { expect(User.last).to be_present }
  end

  context 'fail' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      facebook_login_failure
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook_error]
      get :facebook, {error_code: '12312'}
    end
    it { expect(User.last).not_to be_present }
  end
end
