require 'rails_helper'

RSpec.describe Category, type: :model do
  subject {
    build(:category)
  }


  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
  end

  describe "Assocations" do
    it { should have_many(:tickets) }
  end

end
