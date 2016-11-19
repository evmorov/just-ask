FactoryGirl.define do

  factory :answer do
    user

    sequence :body do |n|
      "Very useful answer #{n}"
    end
    question
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
