class OauthsController < ApplicationController
  skip_authorization_check

  def ask_email
    @user = User.create_if_not_exist_w_auth(params['email'], params['provider'], params['uid'])

    if @user.confirmed_at
      @user.update(confirmed_at: nil)
      @user.send_confirmation_instructions
    end
    redirect_to root_path
  end

  def ask_username
    @user = User.create_if_not_exist_w_auth(params['email'], params['username'], params['provider'], params['uid'])

    redirect_to root_path
  end
end
