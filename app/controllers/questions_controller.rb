class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  expose :questions, ->{ Question.all }
  expose :question  
  expose :answer, ->{ Answer.new }

  def create
    question.author = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else      
      render :new
    end
  end

  def update    
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if question.author == current_user
      question.destroy
      redirect_to questions_path, notice: 'The question is successfully deleted.'
    else
      redirect_to questions_path, alert: 'You can not delete this question.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
