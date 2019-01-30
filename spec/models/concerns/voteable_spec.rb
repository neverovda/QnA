require 'rails_helper'

RSpec.shared_examples_for "voteable" do

  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:another_user_2) { create(:user) }
  let(:another_user_3) { create(:user) }
  let(:instance_thing) { create(model.to_s.underscore.to_sym, author: user) }
  let(:vote) { create :vote, user: another_user, voteable: instance_thing }
  let(:vote2) { create :vote, user: another_user_2, voteable: instance_thing }

  describe 'method score' do
    it "when 2 like score must be 2" do
      vote.like!
      vote2.like!
      expect(instance_thing.score).to eq 2
    end

    it "when 2 dislike score must be -2" do
      vote.dislike!
      vote2.dislike!
      expect(instance_thing.score).to eq -2
    end

    it "when 1 like and 1 dislike score must be 0" do
      vote.like!
      vote2.dislike!
      expect(instance_thing.score).to eq 0
    end
  end

  describe 'method current_vote(user)' do    
    before { vote }

    it "find vote" do
      expect(instance_thing.current_vote(another_user)).to eq vote
    end

    it "create vote" do
      expect(another_user_3.votes.find_by(voteable: instance_thing)).to eq nil
      expect(instance_thing.current_vote(another_user_3).user).to eq another_user_3
      expect(instance_thing.current_vote(another_user_3).class).to eq Vote
    end

    it "user connot create vote for his thing" do      
      expect(instance_thing.current_vote(user)).to eq nil
    end    
  end


end
