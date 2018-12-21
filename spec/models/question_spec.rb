require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :author }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answers) { create_list(:answer, 3,  question: question, author: user) }
      
  it "#sorted_answers" do
    answers[2].check_best.save
    expect(question.sorted_answers[0]).to be_best
  end

end
