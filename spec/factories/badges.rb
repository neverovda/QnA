FactoryBot.define do
  factory :badge do    
    sequence(:name) { |n| "Badge#{n}" } 
  end
end
