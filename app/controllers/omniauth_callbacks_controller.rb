class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if (@user = User.find_by_auth(auth))
      sign_in_and_redirect_auth('Facebook')
    else
      if User.find_by(email: auth.info.email)
        @user = User.create_if_not_exist_w_auth(auth.info.email, auth.info.username, auth.provider, auth.uid)
        sign_in_and_redirect_auth('Facebook')
      else
        @auth = auth
        render 'registrations/ask_username'
      end
    end
  end

  def twitter
    if (@user = User.find_by_auth(auth))
      sign_in_and_redirect_auth('Twitter')
    else
      if User.find_by(email: auth.info.email)
        @user = User.create_if_not_exist_w_auth(auth.info.email, auth.info.username, auth.provider, auth.uid)
        sign_in_and_redirect_auth('Twitter')
      else
        @auth = auth
        render 'registrations/ask_username'
      end
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
