# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n}" }
    user
    commentable_id { nil }
    commentable_type { nil }
  end
end
