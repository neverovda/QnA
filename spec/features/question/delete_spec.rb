require 'rails_helper'
feature 'User can create question', %q{
  As an owner of question
  I'd like to be able to delete the question
} do
  given(:user) {create(:user)}
  given(:another_user) {create(:user)}
  
  given!(:question) { create(:question, author: user) }
  given!(:foreign_question) { create(:question, author: another_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      
    end
    scenario 'delete his question' do
      expect(page).to have_content question.title
      within(".question_#{question.id}") { click_on 'Delete' }
      expect(page).to have_content 'The question is successfully deleted.'
      expect(page).not_to have_content question.title
    end
    
    scenario 'delete not his question' do
      within(".question_#{foreign_question.id}") do
        expect(page).to have_content foreign_question.title
        expect(page).to_not have_link 'Delete'
      end
    end

  end
  
  scenario 'Unauthenticated user tries to delete a question' do
    visit questions_path
    within(".question_#{question.id}") do 
      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete'
    end  
  end

end
