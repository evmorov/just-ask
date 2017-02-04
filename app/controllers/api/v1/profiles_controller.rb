class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :me, User
    respond_with current_resource_owner
  end

  def index
    authorize! :index, User
    respond_with User.where.not(id: current_resource_owner.id)
  end
end