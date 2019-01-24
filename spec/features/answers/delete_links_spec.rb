require 'rails_helper'

feature 'Author can delete links from answer', %q{
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  given(:question) { create(:question, :with_file, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:foreign_answer) { create(:answer, question: question, author: another_user) }
  
  given!(:link) { create :link, linkable: answer }
  given!(:foreign_link) { create :link, linkable: foreign_answer }
  
  scenario 'Unauthenticated can not delete links' do
    visit question_path(question)    
    within(".answer_#{answer.id}") do
      expect(page).to have_link 'NameLink'
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link from his answer', js: true do
      within(".answer_#{answer.id}") do
        expect(page).to have_link 'NameLink'
        click_on 'Edit'
        click_on 'Delete link'
        click_on 'Save'
        expect(page).not_to have_link 'NameLink'
      end      
    end

    scenario 'delete link from foreign answer', js: true do
      within(".answer_#{foreign_answer.id}") do
        expect(page).to have_link 'NameLink'
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_link 'Delete link'
      end      
    end

  end
end
