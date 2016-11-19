FactoryGirl.define do
  sequence :question_title do |n|
    "Question title #{n}"
  end

  sequence :question_body do |n|
    "Question body #{n}"
  end

  factory :question do
    user

    title { generate(:question_title) }
    body { generate(:question_body) }

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
