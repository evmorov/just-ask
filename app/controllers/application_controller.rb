require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :error

  before_action :set_gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def set_gon_user
    gon.user_id = current_user.id if current_user
  end
end
