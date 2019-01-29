FactoryBot.define do
  factory :vote do
    sequence(:user) { |n| create :user } 
  end
end
