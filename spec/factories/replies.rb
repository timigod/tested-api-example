FactoryGirl.define do
  factory :reply do
    ticket { @ticket = build(:open_ticket) }
    body { Faker::Lorem.paragraph }
    sender { @ticket.user }
  end
end
