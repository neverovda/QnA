class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  scope :sorted_by_time, -> { order created_at: :asc }
end
