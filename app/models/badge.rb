class Badge < ApplicationRecord
  belongs_to :badgeable, polymorphic: true
 
  validates :name, presence: true
end
