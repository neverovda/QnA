class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  scope :sorted_by_best_and_created, -> { order(best: :desc, created_at: :asc) }

  def check_best!
    another_best = question.answers.where(best: true).first
    if another_best && another_best != self
      another_best.update(best: false)      
    end
    self.best = !best
    self.save  
  end

end
