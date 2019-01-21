class Badge < ApplicationRecord
  belongs_to :badgeable, polymorphic: true
  belongs_to :question, dependent: :destroy

  has_one_attached :image
 
  validates :name, presence: true
end
