require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe 'DELETE #destroy' do    
    
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_file, author: user) }  
    let(:another_user) { create(:user) }
    let(:foreign_question) { create(:question, :with_file, author: another_user) }
    let!(:link) { create :link, linkable: question }
    let!(:foreign_link) { create :link, linkable: foreign_question }
    
    context 'Authenticated user tries' do
      before { login(user) }

      it 'deletes link from his question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'deletes link from his question' do
        expect { delete :destroy, params: { id: foreign_link.id }, format: :js }.not_to change(Link, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link.id }, format: :js
        expect(response).to render_template :destroy
      end

    end

    it 'Not Authenticated user tries deletes a attachment' do
      expect { delete :destroy, params: { id: link.id }, format: :js }.not_to change(Link, :count)
    end
    
  end

end
