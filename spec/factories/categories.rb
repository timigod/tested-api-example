FactoryGirl.define do
  factory :category do
    name Faker::Lorem.word
    slug { name.parameterize }
  end
end
