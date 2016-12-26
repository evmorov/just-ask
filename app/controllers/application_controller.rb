require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :error

  before_action :set_gon_user, unless: :devise_controller?

  private

  def set_gon_user
    gon.user_id = current_user.id if current_user
  end
end
