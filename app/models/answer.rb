class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :sorted_by_best, -> { order(best: :desc, created_at: :asc) }

  def check_best!
    another_best = question.answers.where(best: true).first
    transaction do
      another_best.update!(best: false) if another_best && another_best != self
      self.update!(best: !best)
    end  
  end

end
