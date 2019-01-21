FactoryBot.define do
  factory :badge do    
    sequence(:name) { |n| "Badge#{n}" }
    image { fixture_file_upload(Rails.root.join('spec','images', 'badge.jpg'), 'image/jpeg') }
  end
end
