require 'rails_helper'
feature 'User can log out', %q{
  As an authenticated user
  I'd like to be able to log out
} do
  given(:user) { create(:user) }
  
  scenario 'Registered user tries to sign in and to log out' do
    visit root_path
    click_on 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
   end
end
