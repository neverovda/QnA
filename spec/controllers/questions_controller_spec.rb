require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  it_behaves_like "voteable controller"

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:another_user) { create(:user) }


  describe 'GET #show' do
    before { get :show, params: { id: question } }
    
    it 'assigns new answer for question' do
      expect(assigns(:exposed_answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
    
  end

  describe 'GET #new' do
    before do
      login user
      get :new
    end

    it 'assigns a new Question to exposed_question' do
      expect(assigns(:exposed_question)).to be_a_new(Question)
    end

    it 'assigns new link for question' do
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end

    it 'assigns new badge for question' do
      expect(assigns(:exposed_question).badge).to be_a_new(Badge)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        # count = Question.count

        # post :create, params: { question: attributes_for(:question)}
        ## post :create, params: { question: { title: '123', body: '123'}}
        # expect(Question.count).to eq count + 1
        expect { post :create, params: { question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end  
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end

      it 'created question belongs to current user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:exposed_question).author_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'dose not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end  
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end  
    end
  end

  describe 'PATCH #update' do
    
    context 'Question autor tries update with valid attributes' do
      before { login user }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:exposed_question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Question autor tries update with invalid attributes' do
      before { login user }

      let!(:old_params) { { title: question.title, body: question.body } }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq old_params[:title]
        expect(question.body).to eq old_params[:body]
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'Not question autor tries update with invalid attributes' do
      before { login another_user }

      let!(:old_params) { { title: question.title, body: question.body } }
      before { patch :update, params: { id: question, question: attributes_for(:question) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq old_params[:title]
        expect(question.body).to eq old_params[:body]
      end

    end

  end

  describe 'DELETE #destroy' do
    
    before { question }

    context 'Authenticated user tries' do
      before { login(user) }         
      
      let!(:foreign_question) { create(:question, author: another_user) }

      it 'deletes his question' do
        expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
      end

      it 'deletes not his question' do
        expect { delete :destroy, params: { id: foreign_question } }.not_to change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    it 'Not Authenticated user tries deletes a question' do
      expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
    end  

  end  

end
