require 'rails_helper'
feature "User can get badge when his answer best", %q{
  As an user
  I'd like to be able to get badge
} do
  
  given(:user) { create :user }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:badge) { create(:badge, question: question) }
  
  background do
    sign_in user
    visit question_path(question)
  end

  describe 'User can get badge' do
    
    scenario 'can see reward badge on question page', js: true do
      within(".answer_#{answer.id}") do
        click_on 'Best'
        expect(page).to have_content badge.name
        expect(page).to have_css("img[src*='badge.jpg']")
      end
    end

    scenario "can see reward badge on badges's page", js: true do
      within(".answer_#{answer.id}") do
        click_on 'Best'        
      end
      visit badges_path
      expect(page).to have_content badge.name
      expect(page).to have_css("img[src*='badge.jpg']")
    end


  end
end
