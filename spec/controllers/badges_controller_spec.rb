require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:badges) { create_list(:badge, 3, question: question, user: user) }

  describe 'GET #index' do
    before do 
      login user
      get :index
    end

    it 'assigns badges' do
      expect(assigns(:badges)).to match_array(badges)      
    end

    it 'renders show index' do
      expect(response).to render_template :index
    end
  end  

end
