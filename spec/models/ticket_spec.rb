require 'rails_helper'

RSpec.describe Ticket, type: :model do
  subject {
    build(:open_ticket)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:category_id) }
  end

  describe "Assocations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should belong_to(:assignee) }
    it { should have_many(:replies) }
  end

  describe "assign_support" do
    it 'sends an email to support' do
      expect { subject.assign_support }
          .to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end

end
