class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  expose :questions, ->{ Question.all }
  expose :question  
  expose :answer, ->{ Answer.new }

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else      
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'The question is successfully deleted.'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
