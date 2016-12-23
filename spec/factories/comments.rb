FactoryGirl.define do
  factory :comment do
    user

    body 'Body of the comment'
  end

  factory :invalid_comment, class: Comment do
    body 'abc'
  end
end
