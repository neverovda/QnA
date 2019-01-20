require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }
  it { should belong_to :badgeable }
  
  it { should validate_presence_of :name }  
end
