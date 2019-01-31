require 'rails_helper'
feature "User can see score votes", %q{
  As an user
  I'd like to be able to see score votes from
  answer
) } do
  
  given(:user) { create :user }
  given(:question) { create :question, author: user }
  
  given(:answer) { create :answer, question: question }
  given(:another_answer) { create :answer, question: question }
  
  given!(:votes!) { create_list(:vote, 10, voteable: answer, value: 1 ) }
  given!(:votes2!) { create_list(:vote, 5, voteable: answer ) }
  given!(:votes3!) { create_list(:vote, 6, voteable: answer, value: -1 ) }
  given!(:another_votes!) { create_list(:vote, 8, voteable: another_answer, value: 1 ) }
  given!(:another_votes2!) { create_list(:vote, 2, voteable: another_answer ) }
  given!(:another_votes3!) { create_list(:vote, 2, voteable: another_answer, value: -1 ) }
   
  scenario "Score must be 4" do    
    visit question_path(question)    
    within(".answer_#{answer.id} .score") { expect(page).to have_content /\A4/ }
  end
    
end
