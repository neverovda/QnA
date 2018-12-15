FactoryBot.define do
  
  factory :question do
    sequence(:title) { |n| "MyQuestionTitle#{n}" }
    sequence(:body) { |n| "MyQuestionText#{n}" }
 
    trait :invalid do
      title { nil }
    end  
  end
end
