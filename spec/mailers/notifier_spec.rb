require "rails_helper"

RSpec.describe Notifier, type: :mailer do

  describe 'support_assignment' do
    let(:support) { build(:support) }
    let(:ticket) { build(:open_ticket) }
    let(:mail) { described_class.support_assignment(support, ticket).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Alert!!! Somebody Needs Support')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([support.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['notifier@crossover-support.com'])
    end

    it 'assigns support name' do
      expect(mail.body.encoded).to match(support.first_name)
    end

    it 'assigns user name' do
      expect(mail.body.encoded).to match(ticket.user.first_name)
    end
  end
end
