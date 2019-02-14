class CommentsController < ApplicationController
  
  before_action :authenticate_user!
    
  def create
    @commentable = commentable
    @comment = @commentable.comments.new(author: current_user, 
                                       body: commentable_params[:body])    
    @comment.save
  end
  
  private

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def commentable
    commentable_klass.find(params[commentable_id_name])
  end

  def commentable_klass
    commentable_id_name.chomp('_id').classify.constantize
  end

  def commentable_id_name
    @commentable_id ||= params.keys.select{ |key| key[/.+_id\z/] }.first
  end

end
