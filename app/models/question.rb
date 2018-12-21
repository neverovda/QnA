class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def sorted_answers
    answers.order(best: :desc, created_at: :asc)
  end  

end
