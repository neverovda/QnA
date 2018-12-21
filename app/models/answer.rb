class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  before_save :uncheck_another_best

  def check_best
    if best
      self.best = false
    else        
      self.best = true
    end
    self  
  end

  private

  def uncheck_another_best
    return unless best

    best_answer = question.answers.where(best: true).first
    if best_answer
      best_answer.best = false
      best_answer.save
    end
  end

end
