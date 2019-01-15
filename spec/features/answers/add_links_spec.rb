require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, author: user)}
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}
  given(:gist_url_2) { 'https://gist.github.com/neverovda/c98d3a71503d2a08b8576a9e7483dcbb' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds link when give an answer', js: true do
      fill_in 'Your answer', with: 'My answer'

      click_on 'Add link'
      within('#links nested-fields:nth-child(1)') do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end  
      
      click_on 'Add link'
      within('#links nested-fields:nth-child(2)') do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: gist_url_2
      end

      click_on 'Post your answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist 2', href: gist_url_2
      end
    end

    scenario 'adds invalid link when give an answer', js: true do
      fill_in 'Your answer', with: 'My answer'

      click_on 'Add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'it is not url'
                
      click_on 'Post your answer'

      expect(page).to have_content "is not a valid URL"
      expect(page).not_to have_link 'My gist'
    end

  end
end
