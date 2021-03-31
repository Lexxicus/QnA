# frozen_string_literal: true

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

    factory :question_with_file do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join('spec', 'files', 'test.jpg')),
                              filename: 'test.jpg',
                              content_type: 'image/jpeg')
      end
    end
  end
end
