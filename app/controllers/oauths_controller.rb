class OauthsController < ApplicationController
  def register_wo_email
    @user = User.create_if_not_exist_w_auth(params['email'], params['provider'], params['uid'])

    if @user.persisted?
      if @user.confirmed_at
        @user.confirmed_at = nil
        @user.save
        @user.send_confirmation_instructions
      end
      redirect_to root_path
    end
  end
end
