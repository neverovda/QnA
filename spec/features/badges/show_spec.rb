require 'rails_helper'
feature "User can see his badges", %q{
  As an user
  I'd like to be able to see my badges
} do
  given(:user) { create :user }
  given!(:badge) { create(:badge, badgeable: user) }
  given(:another_user) { create :user }
  given!(:foreign_badge) { create(:badge, badgeable: another_user) }
  
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
