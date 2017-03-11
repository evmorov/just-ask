class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_oauth('Facebook')
  end

  def twitter
    sign_in_oauth('Twitter')
  end

  private

  def sign_in_oauth(provider_name)
    user = User.find_by(email: auth.info.email)
    if user # has user
      unless user.authorizations.find_by(uid: auth.uid) # but doesn't have authorization
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      end
      sign_in_and_redirect_auth(user, provider_name)
    else # doesn't have a user and authorization
      @auth = auth
      render 'registrations/ask_username'
    end
  end

  def sign_in_and_redirect_auth(user, provider_name)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
  end

  def auth
    request.env['omniauth.auth']
  end
end
