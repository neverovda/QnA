class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true
  validate :user_cannot_vote_by_his_thing

  def like!
    if self.value == 1
      self.value = 0
    else
      self.value = 1
    end
    self.save
  end

  def dislike!
    if self.value == -1
      self.value = 0
    else
      self.value = -1
    end
    self.save
  end

  private

  def user_cannot_vote_by_his_thing
    if user&.author_of?(voteable)
      errors.add(:user, "can't vote by his thing")
    end
  end

end
