require 'rails_helper'
feature "User can add like", %q{
  As an user
  I'd like to be able to add like to
  question or answer
} do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given(:foreign_question) { create(:question, author: another_user) }
    
  scenario 'Unauthenticated can not add like' do
    visit question_path(question)
    within '.question-scopes' do
      expect(page).not_to have_link 'Like'
    end
  end

  scenario 'Unauthenticated can not add dislike' do
    visit question_path(question)
    within '.question-scopes' do
      expect(page).not_to have_link 'Dislike'
    end
  end

  describe 'Authenticated user' do
    background { sign_in user }
      
    scenario 'tries to add like to his question' do
      visit question_path(question)
      within '.question-scopes' do
        expect(page).not_to have_link 'Like'
      end
    end

    scenario 'tries to add dislike to his question' do
      visit question_path(question)
      within '.question-scopes' do
        expect(page).not_to have_link 'Dislike'
      end
    end

    scenario "tries to add like to foreign question", js: true do
      visit question_path(foreign_question)
      within('.question-scopes') do
        expect(page).to have_content '0'
        click_on "Like"
        expect(page).to have_content /\A1/
      end
    end

    scenario "tries to add dislike to foreign question", js: true do
      visit question_path(foreign_question)
      within('.question-scopes') do
        expect(page).to have_content '0'
        click_on "Dislike"
        expect(page).to have_content /\A-1/
      end
    end    
  
  end  
end
