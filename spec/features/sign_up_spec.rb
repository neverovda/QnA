require 'rails_helper'
feature 'User can sign up', %q{
  As an unregistered user
  I'd like to be able to sign un
} do
  given(:first_user) { create(:user) }

  background do 
    visit root_path
    click_on 'Sign up'
  end

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with not valide data' do
    click_button 'Sign up'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end  
  
  scenario 'User tries to sign up with taken email' do
    fill_in 'Email', with: first_user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'    
    expect(page).to have_content 'Email has already been taken'
  end
end
