# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) {|n| "someemail#{n}@awesomeanswer.com" }
    password Faker::Internet.password(10)
  end
end
