require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do    
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    
    let(:another_user) { create(:user) }
    let(:foreign_question) { create(:question, author: another_user) }

    before do
      @attachment = attach_to(question.files)
      @foreign_attachment = attach_to(foreign_question.files)
    end    

    context 'Authenticated user tries' do
      before { login(user) }

      it 'deletes his attachment' do
        expect { delete :destroy, params: { id: @attachment.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'deletes not his attachment' do
        expect { delete :destroy, params: { id: @foreign_attachment.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end     
    end

    it 'Not Authenticated user tries deletes a attachment' do
      expect { delete :destroy, params: { id: @attachment.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end  
  end

end
