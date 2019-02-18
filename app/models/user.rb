class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: :author_id, dependent: :nullify
  has_many :answers, foreign_key: :author_id, dependent: :nullify
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :badges
  has_many :votes, dependent: :destroy

  def author_of?(thing)
    id == thing.author_id
  end

  def not_author_of?(thing)
    !author_of?(thing)
  end

end
