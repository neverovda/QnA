require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:gist_url_2) { 'https://gist.github.com/neverovda/c98d3a71503d2a08b8576a9e7483dcbb' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

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
      fill_in 'Url', with: gist_url_2
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My gist 2', href: gist_url_2
  end

end
