class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
    
  expose :question
  expose :answer

  def create    
    answer.question = question
    if answer.save
      redirect_to answer.question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
