# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n}" }
    user
    commnetable factory: :question
  end
end
