require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it { should validate_presence_of :value }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:vote) { Vote.create(user: another_user, voteable: question) }
  let(:not_valid_vote) { Vote.new(user: user, voteable: question) }
  
  it 'should default value to 0' do
    # vote.value.should == 0
    expect(vote.value).to eq 0
  end  

  describe 'method like!' do
    
    it "when value 0" do
      vote.like!
      expect(vote.value).to eq 1
    end

    it "when value 1" do
      vote.value = 1
      vote.like!
      expect(vote.value).to eq 0
    end

    it "when value -1" do
      vote.value = -1
      vote.like!
      expect(vote.value).to eq 1
    end
  end

  describe 'method dislike!' do
    
    it "when value 0" do
      vote.dislike!
      expect(vote.value).to eq -1
    end

    it "when value 1" do
      vote.value = 1
      vote.dislike!
      expect(vote.value).to eq -1
    end

    it "when value -1" do
      vote.value = -1
      vote.dislike!
      expect(vote.value).to eq 0
    end
  end

  describe 'validate method user_cannot_vote_by_his_thing' do    
    it "valid vote" do
      vote.valid?
      expect(vote.errors[:user]).not_to include("can't vote by his thing")
    end

    it "not valid vote" do
      not_valid_vote.valid?
      expect(not_valid_vote.errors[:user]).to include("can't vote by his thing")      
    end
  end
  
end
