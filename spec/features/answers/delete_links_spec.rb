require 'rails_helper'

feature 'Author can delete links from answer', %q{
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create :link, linkable: answer }
  
  scenario 'Authenticated user delete link from his answer', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_link 'NameLink'

    within(".answer_#{answer.id}") do
      click_on 'Edit'
      click_on 'Delete link'
      click_on 'Save'
    end
    expect(page).not_to have_link 'NameLink'
  end

end
