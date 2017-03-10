FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    email
    username
    password '12345678'
    password_confirmation '12345678'
    confirmed_at '2017-01-16 20:02:19.357931'

    factory :admin do
      admin true
    end
  end
end
