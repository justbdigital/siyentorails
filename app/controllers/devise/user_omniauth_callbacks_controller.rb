class Devise::UserOmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_omniauth request.env['omniauth.auth']
    user.save!
    sign_in_and_redirect user
  end

  def failure
    flash[:error] = params[:error_message]
    redirect_to root_path
  end
end
