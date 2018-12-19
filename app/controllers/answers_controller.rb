class AnswersController < ApplicationController
  before_action :authenticate_user!
    
  expose :question
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user
    answer.save
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'The answer is successfully deleted.'
    end
    redirect_to answer.question
  end

  def update    
    answer.update(answer_params)
    @question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
