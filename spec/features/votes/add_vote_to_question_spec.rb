require 'rails_helper'
feature "User can add vote", %q{
  As an user
  I'd like to be able to add vote to
  question
} do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given(:foreign_question) { create(:question, author: another_user) }
    
  scenario 'Unauthenticated can not add like' do
    visit question_path(question)
    within '.question-score' do
      expect(page).not_to have_link 'Like'
    end
  end

  scenario 'Unauthenticated can not add dislike' do
    visit question_path(question)
    within '.question-score' do
      expect(page).not_to have_link 'Dislike'
    end
  end

  describe 'Authenticated user' do
    background { sign_in user }
      
    scenario 'tries to add like to his question' do
      visit question_path(question)
      within '.question-score' do
        expect(page).not_to have_link 'Like'
      end
    end

    scenario 'tries to add dislike to his question' do
      visit question_path(question)
      within '.question-score' do
        expect(page).not_to have_link 'Dislike'
      end
    end

    scenario "tries to add like to foreign question", js: true do
      visit question_path(foreign_question)
      within('.question-score') do
        expect(page).to have_content '0'
        click_on "Like"        
      end
      within('.score') { expect(page).to have_content /\A1/ }
    end

    scenario "tries to add dislike to foreign question", js: true do
      visit question_path(foreign_question)
      within('.question-score') do
        expect(page).to have_content '0'
        click_on "Dislike"        
      end
      within('.score') { expect(page).to have_content /\A-1/ }
    end    
  
  end  
end
