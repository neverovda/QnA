require 'rails_helper'
feature 'User can choose best answer', %q{
  As an owner of question
  I'd like to be able to check the best answer
} do
  given!(:user) {create(:user)}
  given!(:another_user) {create(:user)}
  
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create :answer, question: question, author: another_user }
  given!(:another_answer) { create :answer, question: question, author: another_user }
  
  scenario 'Unauthenticated user tries to check the best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end

  scenario 'Not owner of question tries to check the best answer' do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end


  describe 'Authenticated owner of question' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'check the best answer', js: true do
      within(".answer_#{answer.id}") do
        expect(page).not_to have_content "Best answer!"
        click_on 'Best'
        expect(page).to have_content "Best answer!"
      end
    end
    
    scenario 'uncheck the best answer', js: true do
      within(".answer_#{answer.id}") do
        click_on 'Best'
        expect(page).to have_content "Best answer!"
        click_on 'Best'
        expect(page).not_to have_content "Best answer!"
      end
    end

    scenario 're-select the best answer', js: true do
      within(".answer_#{answer.id}") do 
        click_on 'Best' 
        expect(page).to have_content "Best answer!"
      end
      within(".answer_#{another_answer.id}") do 
        click_on 'Best'
        expect(page).to have_content "Best answer!"
      end
      within(".answer_#{answer.id}") do 
        expect(page).not_to have_content "Best answer!"
      end
    end

    scenario 'the best answer must bo first of list',js: true do
      within(".answer_#{answer.id}") { click_on 'Best' }
      within all('.answer').first { expect(page).to have_content "Best answer!" }
  
      within(".answer_#{another_answer.id}") { click_on 'Best' }
      within all('.answer').first { expect(page).to have_content "Best answer!" }
    end  

  end

end
