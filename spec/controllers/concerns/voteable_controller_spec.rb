require 'rails_helper'

RSpec.shared_examples_for "voteable controller" do

  describe 'POST #like' do
    before { question }

    context 'Authenticated user tries' do
      it 'like not his question' do
        login another_user
        expect { post :like, params: { id: question } }.to change {question.score}.by(1)
      end

      it 'like his question' do
        login user
        expect { post :like, params: { id: question } }.not_to change{question.score}
      end
    end

    it 'Not Authenticated user tries like question' do
      expect { post :like, params: { id: question } }.not_to change{question.score}
    end

    it 'Response must be json' do
      login another_user
      post :like, params: { id: question }
      body = { score: question.score }
      expect(response.body).to eq body.to_json
    end
  end

  describe 'POST #dislike' do
    before { question }

    context 'Authenticated user tries' do
      it 'dislike not his question' do
        login another_user
        expect { post :dislike, params: { id: question } }.to change {question.score}.by(-1)
      end

      it 'dislike his question' do
        login user
        expect { post :dislike, params: { id: question } }.not_to change{question.score}
      end
    end

    it 'Not Authenticated user tries dislike question' do
      expect { post :dislike, params: { id: question } }.not_to change{question.score}
    end

    it 'Response must be json' do
      login another_user
      post :dislike, params: { id: question }
      body = { score: question.score }
      expect(response.body).to eq body.to_json
    end
  end
  
end
