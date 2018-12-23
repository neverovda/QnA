require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:another_user) { create(:user) }
  
  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer)}, format: :js }.to change(question.answers, :count).by(1)
      end  
      
      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'created answer belongs to current user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:exposed_answer).author_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'dose not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(Answer, :count)
      end  
      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end  
    end
  end

  describe 'DELETE #destroy' do
    
    context 'Authenticated user tries' do
      before { login(user) }
            
      let!(:foreign_answer) { create(:answer, question: question, author: another_user) }

      it 'deletes his answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(user.answers, :count).by(-1)
      end

      it 'deletes not his question' do
        expect { delete :destroy, params: { id: foreign_answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'redders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    it 'Not Authenticated user tries deletes a answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
    end  
  end

  describe 'PATCH #update' do
    
    context 'Answer author tries to update answer' do
      before { login(user) }
      
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Not answer author tries to update answer' do
      before { login another_user }
     
      it 'can not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end

  end

  describe 'POST #best' do
    
    context 'Question author tries to mark answer best' do
      before { login user }
    
      it 'check best the answer' do
        post :best, params: { id: answer }, format: :js
        expect { answer.reload }.to change(answer, :best?)
      end

      it 'renders best template' do
        post :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end      
    end    

    context 'Not question author tries to mark answer best' do
      
      before { login another_user }

      it 'doesn`t make answer best' do
        post :best, params: { id: answer, format: :js }
        expect { answer.reload }.not_to change(answer, :best?)
      end

      it 'renders best template' do
        post :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

  end

end
