require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :badgeable }
  # it { should belong_to :ouner }

  it { should validate_presence_of :name }  
end
