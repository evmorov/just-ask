class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    unless (@user = User.find_by_auth(auth))
      @user = User.create_if_not_exist_w_auth(auth.info.email, auth.provider, auth.uid)
    end
    sign_in_and_redirect_auth('Facebook')
  end

  def twitter
    if (@user = User.find_by_auth(auth))
      sign_in_and_redirect_auth('Twitter')
    else
      @auth = auth
      render 'registrations/ask_email'
    end
  end

  private

  def sign_in_and_redirect_auth(provider)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end

  def auth
    request.env['omniauth.auth']
  end
end
