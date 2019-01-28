class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable
  has_one :badge, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def score
    votes.sum(:value)
  end

  def current_vote(user)
    return if user.author_of?(self)
    votes.find_by(user: user) || votes.create(user: user)
  end
end
