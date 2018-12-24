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
    answer.destroy if current_user.author_of?(answer)
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @exposed_question = answer.question
  end

  def best
    answer.check_best! if current_user.author_of?(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end  

end
