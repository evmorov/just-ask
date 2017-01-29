class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  before_action :load_attachment
  before_action :forbidden_unless_author_of_attachable

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def forbidden_unless_author_of_attachable
    head :forbidden unless current_user.author_of? @attachment.attachable
  end
end
