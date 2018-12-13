class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
    
  expose :question
  expose :answer

  def create    
    answer.author = current_user
    answer.question = question
    if answer.save
      redirect_to answer.question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if answer.author == current_user
      answer.destroy
      redirect_to answer.question, notice: 'The answer is successfully deleted.'
    else
      redirect_to answer.question, alert: 'You can not delete this answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
