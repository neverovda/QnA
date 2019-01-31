class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [-1, 0, 1] }
  validate :user_cannot_vote_by_his_thing

  def like!
    vote!(1)
  end

  def dislike!
    vote!(-1)        
  end

  private

  def vote!(value)
    if self.value != value
      self.value = value
      self.save
    else
      self.destroy  
    end    
  end

  def user_cannot_vote_by_his_thing
    if user&.author_of?(voteable)
      errors.add(:user, "can't vote by his thing")
    end
  end

end
