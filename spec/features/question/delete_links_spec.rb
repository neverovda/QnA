require 'rails_helper'

feature 'Author can delete links from question', %q{
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }
  given!(:link) { create :link, linkable: question }
  
  scenario 'Authenticated user delete link from his question', js: true do
    sign_in user
    visit question_path(question)
    click_on 'Edit question'
    
    within('#question_links') do
      expect(page).to have_field('Link name', with: 'NameLink')
      click_on 'Delete link'
    end

    click_on 'Save'
    expect(page).not_to have_link 'NameLink'
  end

end
