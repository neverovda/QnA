require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question } 
  it { should belong_to :author }

  it { should validate_presence_of :body }

  describe 'best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }
    
    context '#check_best' do
      it "check" do
        answer.check_best
        expect(answer).to be_best
      end

      it 'un-check' do
        answer.check_best
        expect(answer).to be_best
        answer.check_best
        expect(answer).not_to be_best
      end
    end

    it 'only one answer must be best' do
      answer.check_best.save
      another_answer.check_best.save
      expect(question.answers.where(best: true).count).to eq 1
    end
  end

end
