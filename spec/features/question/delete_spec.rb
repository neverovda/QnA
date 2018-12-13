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
      find(".btn-delete[data-question-id=\"#{question.id}\"]").click
      expect(page).to have_content 'The question is successfully deleted.'
      expect(page).not_to have_content question.title
    end
    scenario 'delete not his question' do
      expect(page).to have_content foreign_question.title
      find(".btn-delete[data-question-id=\"#{foreign_question.id}\"]").click
      expect(page).to have_content 'You can not delete this question.'
      expect(page).to have_content foreign_question.title
    end
  end
  scenario 'Unauthenticated user tries to delete a question' do
    visit questions_path
    expect(page).to have_content question.title
    find(".btn-delete[data-question-id=\"#{question.id}\"]").click
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    visit questions_path
    expect(page).to have_content question.title
  end
end
