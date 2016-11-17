FactoryGirl.define do
  sequence :body do |n|
    "Very useful answer #{n}"
  end

  factory :answer do
    body
    question
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
