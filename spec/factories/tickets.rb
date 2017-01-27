FactoryGirl.define do
  factory :ticket do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user { User.where(role: :registered).sample }
    category { create(:category) }

    factory :open_ticket do
      status :open
    end

    factory :closed_ticket do
      status :closed
    end

  end
end
