FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  sequence :body do |n|
    "QuestionBody#{n}"
  end

  factory :question do
    title
    body
    user
    best_answer_id { nil }

    trait :invalid do
      title { nil }
    end
  end
end
