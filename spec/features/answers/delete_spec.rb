require 'rails_helper'
feature 'User can delete answer', %q{
  As an owner of answer
  I'd like to be able to delete the answer
} do
  given(:user) {create(:user)}
  given(:another_user) {create(:user)}
  
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:foreign_answer) { create(:answer, question: question, author: another_user) }

  describe 'Authenticated user' do    
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'delete his answer', js: true do
      expect(page).to have_content answer.body
      within(".answer_#{answer.id}") { click_on 'Delete' }
      expect(page).not_to have_content answer.body
    end
    
    scenario 'delete not his answer', js: true do
      within(".answer_#{foreign_answer.id}") do
        expect(page).to have_content foreign_answer.body
        expect(page).to_not have_link 'Delete'
      end  
    end

  end
  
  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)
    within(".answer_#{answer.id}") do
      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Delete'
    end  
  end

end
