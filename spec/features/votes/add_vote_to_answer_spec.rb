require 'rails_helper'
feature "User can add vote", %q{
  As an user
  I'd like to be able to add vote to
  answer
} do
  
  given(:user) { create :user }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  
  given!(:user_answer) { create :answer, question: question, author: user }
  given!(:foreign_answer) { create :answer, question: question }
    
  scenario 'Unauthenticated can not add like' do
    visit question_path(question)
    within ".answer_#{foreign_answer.id} .answer-score" do
      expect(page).not_to have_link 'Like'
    end
  end

  scenario 'Unauthenticated can not add dislike' do
    visit question_path(question)
    within ".answer_#{foreign_answer.id} .answer-score" do
      expect(page).not_to have_link 'Dislike'
    end
  end

  describe 'Authenticated user' do
    background { sign_in user }
      
    scenario 'tries to add like to his answer' do
      visit question_path(question)
      within ".answer_#{user_answer.id} .answer-score" do
        expect(page).not_to have_link 'Like'
      end
    end

    scenario 'tries to add dislike to his answer' do
      visit question_path(question)
      within ".answer_#{user_answer.id} .answer-score" do
        expect(page).not_to have_link 'Dislike'
      end
    end

    scenario "tries to add like to foreign answer", js: true do
      visit question_path(question)
      within(".answer_#{foreign_answer.id} .answer-score") do
        expect(page).to have_content '0'
        click_on "Like"        
      end
      within(".answer_#{foreign_answer.id} .score") { expect(page).to have_content /\A1/ }
    end

    scenario "tries to add dislike to foreign answer", js: true do
      visit question_path(question)
      within(".answer_#{foreign_answer.id} .answer-score") do
        expect(page).to have_content '0'
        click_on "Dislike"        
      end
      within(".answer_#{foreign_answer.id} .score") { expect(page).to have_content /\A-1/ }
    end    
  
  end

  context "Multiple sessions, answer appears on another user's page and authenticated user can vote" do
    scenario "Unauthenticated can not add like", js: true do
      Capybara.using_session('user') do
        sign_in(user)        
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text text text'
        click_on 'Post your answer'        
      end

      Capybara.using_session('guest') do        
        expect(page).to have_content 'text text text'        
        within(".answer_#{foreign_answer.id} .answer-score") do          
          expect(page).not_to have_link 'Like'
        end
        
      end
    end

    scenario "Unauthenticated can not add like", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text text text'
        click_on 'Post your answer'        
      end

      Capybara.using_session('guest') do        
        expect(page).to have_content 'text text text'        
        within(".answer_#{foreign_answer.id} .answer-score") do          
          expect(page).not_to have_link 'Dislike'
        end        
      end
    end

    scenario "Authenticated user add like to foreign answer", js: true do
      Capybara.using_session('user') do
        sign_in(user)        
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text text text'
        click_on 'Post your answer'        
      end

      Capybara.using_session('guest') do        
        expect(page).to have_content 'text text text'        
        within(".answer_#{foreign_answer.id} .answer-score") do          
          click_on "Like"
        end
        within(".answer_#{foreign_answer.id} .score") { expect(page).to have_content /\A1/ }
      end
    end

    scenario "Authenticated user add dislike to foreign answer", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'text text text'
        click_on 'Post your answer'        
      end

      Capybara.using_session('guest') do        
        expect(page).to have_content 'text text text'        
        within(".answer_#{foreign_answer.id} .answer-score") do          
          click_on "Dislike"
        end
        within(".answer_#{foreign_answer.id} .score") { expect(page).to have_content /\A-1/ }
      end
    end
  end

end
