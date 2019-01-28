require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it { should validate_presence_of :value }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:vote) { Vote.new(user: user, voteable: question) }
  
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

  # def user_cannot_vote_by_his_thing
end
