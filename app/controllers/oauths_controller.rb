class OauthsController < ApplicationController
  skip_authorization_check

  def ask_username
    auth = {
      email: params['email'],
      username: params['username'],
      provider: params['provider'],
      uid: params['uid']
    }
    @user = User.create_user_and_auth(auth)
    redirect_to root_path
  end
end
