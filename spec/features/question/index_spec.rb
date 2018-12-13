require 'rails_helper'
feature 'User can see question list', %q{
  As an user
  I'd like to be able to see question list
} do
  given(:user) { create :user }
  given!(:questions) { create_list :question, 3, author: user }

  scenario 'User tries to see a question list' do
    visit questions_path    
    questions.each do |q| 
      expect(page).to have_content q.title      
    end  
  end
end
