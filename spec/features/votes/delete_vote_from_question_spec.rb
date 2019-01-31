require 'rails_helper'
feature "User can delete vote", %q{
  As an ouner of vote
  I'd like to be able to delete vote from
  question
} do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given(:like) { create :vote, user: another_user, voteable: question, value: 1 }
  given(:dislike) { create :vote, user: another_user, voteable: question, value: -1 }

  describe 'Owner of vote' do
    background { sign_in another_user }
    
    scenario "tries to delete like", js: true do
      like
      visit question_path(question)
      within('.question-score') do
        expect(page).to have_content '1'
        click_on "Like"
      end
      within('.score') { expect(page).to have_content /\A0/ }
    end

    scenario "tries to delete dislike", js: true do
      dislike
      visit question_path(question)
      within('.question-score') do
        expect(page).to have_content '-1'
        click_on "Dislike"
      end
      within('.score') { expect(page).to have_content /\A0/ }
    end
  end    
    
end
