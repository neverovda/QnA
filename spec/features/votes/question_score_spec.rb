require 'rails_helper'
feature "User can see score votes", %q{
  As an user
  I'd like to be able to see score votes from
  question
) } do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given(:foreing_question) { create(:question, author: user) }
  
  given!(:votes!) { create_list(:vote, 10, voteable: question, value: 1 ) }
  given!(:votes2!) { create_list(:vote, 5, voteable: question ) }
  given!(:votes3!) { create_list(:vote, 6, voteable: question, value: -1 ) }
  given!(:foreing_votes!) { create_list(:vote, 8, voteable: foreing_question, value: 1 ) }
  given!(:foreing_votes2!) { create_list(:vote, 2, voteable: foreing_question ) }
  given!(:foreing_votes3!) { create_list(:vote, 2, voteable: foreing_question, value: -1 ) }
   
  scenario "Score must be 4" do    
    visit question_path(question)
    within('.score') { expect(page).to have_content /\A4/ }
  end
    
end
