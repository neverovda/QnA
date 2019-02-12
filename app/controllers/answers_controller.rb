class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  expose :question
  expose :answer, scope: ->{ Answer.with_attached_files }

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

  def publish_answer
    return if answer.errors.any?
    AnswersChannel.broadcast_to(
      answer.question, 
      answer: answer,
      files: helpers.urls(answer.files),
      links: helpers.links(answer.links))
  end  

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end  

end
