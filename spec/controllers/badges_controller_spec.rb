require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:foreign_answer) { create(:answer, question: question, author: another_user) }
  

  let!(:badge) { create(:badge, question: question, badgeable: answer) }
  let!(:foreign_badge) { create(:badge, question: question, badgeable: foreign_answer) }


  describe 'GET #index' do
    before do 
      login user
      get :index
    end

    it 'assigns badges' do
      expect(assigns(:badges)).to eq user.badges      
    end

    it 'renders show index' do
      expect(response).to render_template :index
    end
  end  

end
