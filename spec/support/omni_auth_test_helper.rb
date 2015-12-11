module OmniAuthTestHelper
  def valid_facebook_login_setup
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        first_name: "Genri",
        last_name:  "Ford",
        email:      "test@example.com"
      },
      credentials: {
        token: "123456",
        expires_at: Time.now + 1.week
      },
      extra: {
        raw_info: {
          gender: 'male'
        }
      }
    })
  end

  def facebook_login_failure
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :error_code => '1349126',
      :error_message  => "App Not Setup: This app is still in development mode, and you don't have access to it. Switch to a registered test user or ask an app admin for permissions."
    })
  end
end
