require 'rails_helper'

feature 'Author can delete links from answer', %q{
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, author: user) }
  given(:another_user) { create(:user) }

  given(:answer) { create(:answer, question: question, author: user) }
  given(:foreign_answer) { create(:answer, question: question, author: another_user) }
  
  given(:link) { create :link, linkable: answer }
  given(:foreign_link) { create :link, linkable: foreign_answer }

  scenario 'Unauthenticated can not delete link' do
    link
    visit question_path(question)
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'delete link from his answer', js: true do
      link
      visit question_path(question)
      expect(page).to have_link 'NameLink'
      click_on 'Delete link'
      expect(page).not_to have_link 'NameLink'
    end
    
    scenario 'can not delete link from foreign answer' do
      foreign_link
      visit question_path(question)
      expect(page).to_not have_link 'Delete link'
    end
  end

end
