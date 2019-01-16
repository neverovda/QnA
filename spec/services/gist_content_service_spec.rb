require 'rails_helper'

RSpec.describe "GistContentService" do
  
  let(:service_with_true_gist) { GistContentService.new('c98d3a71503d2a08b8576a9e7483dcbb') }
  let(:service_with_wrong_gist) { GistContentService.new('wrong_gist') }

  describe 'method content' do
    it "it is gist" do
      expect(service_with_true_gist.content).to eq 'gist text'
    end

    it "it is not gist" do
      expect(service_with_wrong_gist.content).to eq nil
    end
  end

end
