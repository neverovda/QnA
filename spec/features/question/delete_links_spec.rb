require 'rails_helper'

feature 'Author can delete links from question', %q{
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }
  given(:foreign_question) { create(:question, author: another_user) }
  given!(:link) { create :link, linkable: question }
  given!(:foreign_link) { create :link, linkable: foreign_question }
  
  scenario 'Unauthenticated can not delete links' do
    visit question_path(question)    
    expect(page).to_not have_link 'Edit question'
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background { sign_in user }
      
    scenario 'delete link from his question', js: true do
      visit question_path(question)
      click_on 'Edit question'
      
      within('#question_links') do
        expect(page).to have_field('Link name', with: 'NameLink')
        click_on 'Delete link'
      end
      click_on 'Save'
      expect(page).not_to have_link 'NameLink'
    end

    scenario 'delete link from foreign question', js: true do
      visit question_path(foreign_question)
      expect(page).to_not have_link 'Edit question'
      expect(page).to_not have_link 'Delete link'
    end
  end

end
