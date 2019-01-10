require 'rails_helper'

feature 'User can delete file form answer', %q{
  As an author of question
  I'd like ot be able to delete attachment file
  from my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }
  given(:answer) { create(:answer, :with_file, question: question, author: user) }
  given(:foreign_answer) { create(:answer, :with_file, question: question, author: another_user) }
  
  scenario 'Unauthenticated can not delete attachment file' do
    answer
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'delete attachment file from his answer', js: true do
      answer
      visit question_path(question)
      expect(page).to have_link 'spec_helper.rb'
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario 'can not delete attachment file from foreign answer' do
      foreign_answer
      visit question_path(question)
      expect(page).to_not have_link 'Delete file'  
    end  

  end
 end
