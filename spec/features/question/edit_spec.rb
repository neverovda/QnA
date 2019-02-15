require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:another_user) { create(:user) }
  given!(:foreign_question) { create(:question, author: another_user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    
    background { sign_in user }

    scenario 'edits his question', js: true do
      
      visit question_path(question)
      click_on 'Edit question'

      fill_in 'Title', with: 'edited title'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'

      within '.question' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea#question_body'
      end   
      
    end

    scenario 'edits his question with errors', js: true do
      visit question_path(question)
      click_on 'Edit question'
      
      fill_in 'Title', with: ''
      fill_in 'Question', with: ''
      click_on 'Save'
      
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add files to his question', js: true do
      
      visit question_path(question)
      click_on 'Edit question'
      within '.question-form' do 
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end  
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "tries to edit other user's question", js: true do
      visit question_path(foreign_question)
      expect(page).to_not have_link 'Edit question'
    end  
  end
end 
