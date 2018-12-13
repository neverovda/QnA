require 'rails_helper'
feature 'User can create question', %q{
  As an owner of question
  I'd like to be able to delete the question
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
    scenario 'delete his answer' do
      expect(page).to have_content answer.body
      find(".btn-delete[data-answer-id=\"#{answer.id}\"]").click
      expect(page).to have_content 'The answer is successfully deleted.'
      expect(page).not_to have_content answer.body
    end
    scenario 'delete not his answer' do
      expect(page).to have_content foreign_answer.body
      find(".btn-delete[data-answer-id=\"#{foreign_answer.id}\"]").click
      expect(page).to have_content 'You can not delete this answer.'
      expect(page).to have_content foreign_answer.body
    end
  end
  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)
    expect(page).to have_content answer.body
    find(".btn-delete[data-answer-id=\"#{answer.id}\"]").click
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    visit question_path(question)
    expect(page).to have_content answer.body
  end
end
