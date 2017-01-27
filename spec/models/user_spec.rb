require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Validations" do
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:image) }
  end

  describe "Assocations" do
    it { should have_many(:tickets) }
    it { should have_many(:assigned_tickets) }
    it { should have_many(:replies) }
  end
end
