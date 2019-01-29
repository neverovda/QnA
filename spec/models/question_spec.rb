require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should belong_to :author }
  it { should have_many(:votes).dependent(:destroy) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }
  
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:another_user_2) { create(:user) }
  let(:another_user_3) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:vote) { Vote.create(user: another_user, voteable: question) }
  let(:vote2) { Vote.create(user: another_user_2, voteable: question) }

  describe 'method score' do    
    it "when 2 like score must be 2" do
      vote.like!
      vote2.like!
      expect(question.score).to eq 2
    end

    it "when 2 dislike score must be -2" do
      vote.dislike!
      vote2.dislike!
      expect(question.score).to eq -2
    end

    it "when 1 like and 1 dislike score must be 0" do
      vote.like!
      vote2.dislike!
      expect(question.score).to eq 0
    end
  end

  describe 'method current_vote(user)' do    
    before { vote }

    it "find vote" do
      expect(question.current_vote(another_user)).to eq vote
    end

    it "create vote" do      
      expect(another_user_3.votes.find_by(voteable: question)).to eq nil
      expect(question.current_vote(another_user_3).user).to eq another_user_3
      expect(question.current_vote(another_user_3).class).to eq Vote
    end

    it "user connot create vote for his thing" do      
      expect(question.current_vote(user)).to eq nil      
    end    
  end

end
