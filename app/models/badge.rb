class Badge < ApplicationRecord
  belongs_to :badgeable, polymorphic: true
  belongs_to :question, dependent: :destroy
 
  validates :name, presence: true
end
