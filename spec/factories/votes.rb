FactoryGirl.define do
  factory :vote do
    user

    score 1
    votable nil
  end
end
