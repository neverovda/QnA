class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create] 
  
  expose :questions, ->{ Question.all }
  expose :question, scope: ->{ Question.with_attached_files }  
  expose :answer, ->{ Answer.new }
  
  def show
    answer.links.new
  end

  def new
    question.links.new
    question.badge = Badge.new
  end

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else      
      render :new
    end
  end

  def update
    question.update(question_params) if author_of_question?
  end

  def destroy
    if author_of_question?
      question.destroy
      flash[:notice] = 'The question is successfully deleted.'
    end
    redirect_to questions_path
  end
  
  private

  def publish_question     
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:name, :image])
  end

  def author_of_question?
    current_user.author_of?(question)
  end

end
