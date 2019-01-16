require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/neverovda/c98d3a71503d2a08b8576a9e7483dcbb'}
  given(:img_url) { 'https://avatars.mds.yandex.net/get-pdb/33827/eb8a6815-162a-4ca9-86ae-c395861d981a/s1200' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds links when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      
      click_on 'Add link'
      within('#links nested-fields:nth-child(1)') do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end  
      
      click_on 'Add link'
      within('#links nested-fields:nth-child(2)') do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: img_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist 2', href: img_url
    end

    scenario 'User adds invalid link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      
      click_on 'Add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'it is not url'
      
      click_on 'Ask'

      expect(page).to have_content "is not a valid URL"
      expect(page).not_to have_link 'My gist'
    end

    scenario 'adds gist link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      
      click_on 'Add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      
      click_on 'Ask'

      expect(page).to have_content "gist text"
    end
    
  end
end
