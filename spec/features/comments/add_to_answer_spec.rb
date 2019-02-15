require 'rails_helper'
feature 'User can create commet to answer', %q{
  As an authenticated user
  I'd like to be able to get the comment
  on question's page
} do
  given(:user) {create(:user)}
  given(:question) { create(:question, author: user) }
  given!(:answer) { create :answer, question: question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'Give a comment' do
      within ".answer_#{answer.id}" do
        fill_in 'Your comment', with: 'text text text'
        click_on 'Post comment'
      end
      expect(page).to have_content 'text text text'      
    end
    
    scenario 'Give a comment with errors' do
      within ".answer_#{answer.id}" do
        click_on 'Post comment'
      end      
      expect(page).to have_content "can't be blank"    
    end
  end
  
  scenario 'Unauthenticated user tries to give a commet' do
    visit question_path(question)
    within ".answer_#{answer.id}" do
      expect(page).to_not have_link 'Post comment'
    end    
  end

end
