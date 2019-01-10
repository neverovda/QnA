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
      it "sets best flag to true" do
        answer.check_best!
        expect(answer).to be_best
      end

      it 'sets best flag to false' do
        answer.check_best!
        expect(answer).to be_best
        answer.check_best!
        expect(answer).not_to be_best
      end
    end

    it 'only one answer must be best' do
      answer.check_best!
      another_answer.check_best!
      expect(question.answers.where(best: true).count).to eq 1
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

end
