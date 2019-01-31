FactoryBot.define do
  
  factory :question do
    sequence(:title) { |n| "MyQuestionTitle#{n}" }
    sequence(:body) { |n| "MyQuestionText#{n}" }
    sequence(:author) { |n| create :user }
     
    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { [fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'text/plain')] }
    end
  end
end
