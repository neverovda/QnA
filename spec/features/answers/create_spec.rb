require 'rails_helper'
feature 'User can create answer', %q{
  As an authenticated user
  I'd like to be able to get the answer
  on question's page
} do
  given(:user) {create(:user)}
  given(:question) { create(:question, author: user) }
  
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'Give a answer' do
      fill_in 'answer_body', with: 'text text text'
      click_on 'Post your answer'
      
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end
    
    scenario 'Give a answer with errors' do
      click_on 'Post your answer'
      expect(page).to have_content "can't be blank"
    end
  end
  
  scenario 'Unauthenticated user tries to give a answer' do
    visit question_path(question)
    click_on 'Post your answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
