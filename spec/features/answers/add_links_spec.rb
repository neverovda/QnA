require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, author: user)}
  given(:gist_url) {'https://gist.github.com/neverovda/c98d3a71503d2a08b8576a9e7483dcbb'}
  given(:img_url) { 'https://avatars.mds.yandex.net/get-pdb/33827/eb8a6815-162a-4ca9-86ae-c395861d981a/s1200' }
  given(:answer) { create(:answer, question: question, author: user) }

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
        fill_in 'Url', with: img_url
      end

      click_on 'Post your answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist 2', href: img_url
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

    scenario 'adds gist link when give an answer', js: true do
      fill_in 'Your answer', with: 'My answer'

      click_on 'Add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
                
      click_on 'Post your answer'

      expect(page).to have_content "gist text"
    end
  end

  describe 'Authenticated user edit his answer' do
    background do
      sign_in(user)
      answer
      visit question_path(question)
    end

    scenario 'adds link', js: true do
      
      click_on 'Edit'      
      within('#answer_links') { click_on 'Add link' }
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: gist_url
            
      click_on 'Save'
      expect(page).to have_link 'My link', href: gist_url
      
    end
  end

end
