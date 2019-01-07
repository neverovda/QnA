class AttachmentsController < ApplicationController

  def destroy
    if current_user
      @attachment = ActiveStorage::Attachment.find(params[:id])
      @attachment.purge if current_user.author_of?(@attachment.record)
    end
  end  

end
