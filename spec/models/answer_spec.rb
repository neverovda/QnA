require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question } 
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:another_answer) { create(:answer, question: question, author: user) }

  describe 'best answer' do
        
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

  describe 'reward, sets best flag to true' do
    let!(:badge) { create(:badge, question: question) }

    it "fill badge's answer" do
      answer.check_best!
      expect(answer.badge).to eq badge
    end

    it "fill user's answer" do
      answer.check_best!
      expect(badge.user).to eq user
    end
  end  

end
