require 'rails_helper'
feature 'User can create answer', %q{
  As an authenticated user
  I'd like to be able to get the answer
  on question's page
} do
  given(:user) {create(:user)}
  given(:question) { create(:question, author: user) }
  
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'Give a answer' do
      fill_in 'Your answer', with: 'text text text'
      click_on 'Post your answer'
      
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'Give a answer with attached file' do
      fill_in 'Your answer', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post your answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
    
    scenario 'Give a answer with errors' do
      click_on 'Post your answer'
      expect(page).to have_content "can't be blank"
    end
  end
  
  scenario 'Unauthenticated user tries to give a answer' do
    visit question_path(question)
    click_on 'Post your answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context "Multiple sessions", js: true do
    scenario "answers appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text text text'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Post your answer'
        expect(page).to have_content 'text text text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end


end
