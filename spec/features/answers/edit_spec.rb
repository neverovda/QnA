require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:another_user) { create(:user) }
  given!(:foreign_answer) { create(:answer, question: question, author: another_user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    
    background { sign_in user }

    scenario 'edits his answer', js: true do
      visit question_path(question)
    
      within(".answer_#{answer.id}") do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      visit question_path(question)
    
      within(".answer_#{answer.id}") do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end  
    
    scenario "tries to edit other user's answer" do
      visit question_path(question)
    
      within(".answer_#{foreign_answer.id}") do
        expect(page).to_not have_link 'Edit'
      end
    end

  end
end
