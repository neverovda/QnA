require 'rails_helper'
feature "User can see his badges", %q{
  As an user
  I'd like to be able to see my badges
} do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:foreign_answer) { create(:answer, question: question, author: another_user) }
  

  given!(:badge) { create(:badge, badgeable: answer) }
  given!(:foreign_badge) { create(:badge, badgeable: foreign_answer) }
  
  scenario 'Unauthenticated can not see badges' do
    visit badges_path
    expect(page).not_to have_selector 'h1', text: 'Badges'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit badges_path
    end

    scenario 'tries to see his badge' do      
      expect(page).to have_content badge.name
    end

    scenario "tries to see foreign badge" do
      expect(page).not_to have_content foreign_badge.name
    end
  end  

end