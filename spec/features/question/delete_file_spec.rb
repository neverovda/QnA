require 'rails_helper'

feature 'User can delete file', %q{
  As an author of question
  I'd like ot be able to delete attachment file
  from my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, author: user) }
  given(:another_user) { create(:user) }
  given(:foreign_question) { create(:question, :with_file, author: another_user) }
  

  scenario 'Unauthenticated can not delete attachment file' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'delete attachment file from his question', js: true do
      visit question_path(question)
      expect(page).to have_link 'spec_helper.rb'
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario 'can not delete attachment file from foreign question' do
      visit question_path(foreign_question)
      expect(page).to_not have_link 'Delete file'  
    end  

  end
 end   
