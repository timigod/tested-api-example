require 'rails_helper'

RSpec.describe Reply, type: :model do

  describe "Validations" do
    it { should validate_presence_of(:sender_id) }
    it { should validate_presence_of(:ticket_id) }
    it { should validate_presence_of(:body) }
  end

  describe "Assocations" do
    it { should belong_to(:sender) }
    it { should belong_to(:ticket) }
  end

end
