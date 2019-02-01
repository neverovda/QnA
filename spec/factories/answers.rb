FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "AnswerText#{n}" } 
    sequence(:author) { |n| create :user }
    
    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'text/plain')] }
    end
    
  end
end
