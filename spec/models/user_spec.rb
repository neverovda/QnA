require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:badges) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:another_user) { create(:user) }
  let(:foreign_question) { create(:question, author: another_user) }

  describe 'method author_of?' do
    
    it "it is user's question" do      
      expect(user).to be_author_of(question)
    end

    it "it is not user's question" do      
      expect(user).not_to be_author_of(foreign_question)
    end    
  end

  describe 'method not_author_of?' do
    
    it "it is user's question" do      
      expect(user).not_to be_not_author_of(question)
    end

    it "it is not user's question" do      
      expect(user).to be_not_author_of(foreign_question)
    end    
  end  

end
