FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "AnswerText#{n}" } 

    trait :invalid do
      body { nil }
    end
  end
end
