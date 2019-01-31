require 'rails_helper'
feature "User can delete vote", %q{
  As an ouner of vote
  I'd like to be able to delete vote from
  answer
} do
  
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }
    
  given(:like) { create :vote, user: user, voteable: answer, value: 1 }
  given(:dislike) { create :vote, user: user, voteable: answer, value: -1 }

  describe "Owner of answer's vote" do
    background { sign_in user }
    
    scenario "tries to delete like", js: true do
      like
      visit question_path(question)
      within(".answer_#{answer.id} .answer-score") do
        expect(page).to have_content '1'
        click_on "Like"
      end
      within(".answer_#{answer.id} .score") { expect(page).to have_content /\A0/ }
    end

    scenario "tries to delete dislike", js: true do
      dislike
      visit question_path(question)
      within(".answer_#{answer.id} .answer-score") do
        expect(page).to have_content '-1'
        click_on "Dislike"
      end
      within(".answer_#{answer.id} .score") { expect(page).to have_content /\A0/ }
    end
  end    
    
end
