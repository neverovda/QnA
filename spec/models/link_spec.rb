require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:gist_url) {'https://gist.github.com/neverovda/c98d3a71503d2a08b8576a9e7483dcbb'}
  let(:img_url) { 'https://avatars.mds.yandex.net/get-pdb/33827/eb8a6815-162a-4ca9-86ae-c395861d981a/s1200' }
  let(:gist_link) { Link.new(name: 'name', url: gist_url, linkable: question) }
  let(:img_link) { Link.new(name: 'name', url: img_url, linkable: question) }
  
  describe 'method gist?' do  
    it "it is gist" do
      expect(gist_link).to be_gist
    end

    it "it is not gist" do
      expect(img_link).not_to be_gist
    end
  end

  describe 'method gist_content' do  
    it "it is gist" do
      expect(gist_link.gist_content).to eq 'gist text'
    end

    it "it is not gist" do
      expect(img_link.gist_content).to eq nil
    end
  end

end
