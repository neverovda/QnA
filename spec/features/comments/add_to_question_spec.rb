require 'rails_helper'
feature 'User can create commet to question', %q{
  As an authenticated user
  I'd like to be able to get the comment
  on question's page
} do
  given(:user) {create(:user)}
  given(:question) { create(:question, author: user) }
  
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'Give a comment' do
      within '.question' do
        fill_in 'Your comment', with: 'text text text'
        click_on 'Post comment'
      end
      expect(page).to have_content 'text text text'
    end
    
    scenario 'Give a comment with errors' do
      within '.question' do
        click_on 'Post comment'
      end      
      expect(page).to have_content "can't be blank"    
    end
  end
  
  scenario 'Unauthenticated user tries to give a commet' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Post comment'
    end    
  end
  
  scenario "Question's comment appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within '.question' do
        fill_in 'Your comment', with: 'text text text'
        click_on 'Post comment'
      end      
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'text text text'
    end
  end

end
