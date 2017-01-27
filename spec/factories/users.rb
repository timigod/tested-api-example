FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(8) }
    email { Faker::Internet.email }
    image {Faker::Placeholdit.image("200x200", 'jpg')}
    role :registered
    assigned_tickets_count 0
    confirmed_at { DateTime.now }

    factory :support do
      role :support
    end
  end
end
