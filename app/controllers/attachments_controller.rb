class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.author_of? @attachment.attachable
      @attachment.destroy
    else
      head :forbidden
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
