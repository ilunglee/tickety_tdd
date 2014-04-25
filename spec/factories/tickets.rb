# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    association :user, factory: :user
    sequence(:title) {|n| "#{Faker::Company.bs} #{n}" }
    sequence(:body) {|n| "#{Faker::Lorem.paragraph} #{n}" }
    status false
  end
end
