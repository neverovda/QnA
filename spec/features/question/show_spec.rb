require 'rails_helper'
feature "User can see question with it's answers", %q{
  As an user
  I'd like to be able to see question with it's answers
} do
  given(:user) { create :user }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }
  
  background { visit question_path(question) }

  scenario 'User tries to see a question' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario "User tries to see a question's answers" do    
    answers.each { |a| expect(page).to have_content a.body  }    
  end

end
