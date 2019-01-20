require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  
  let!(:badge) { create(:badge, badgeable: user) }
  let!(:foreign_badge) { create(:badge, badgeable: another_user) }


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
