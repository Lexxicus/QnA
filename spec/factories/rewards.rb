# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    sequence(:title) { |n| "Award#{n}" }
    question
    user

    before(:create) do |reward|
      reward.image.attach(io: File.open(Rails.root.join('spec', 'files', 'test.jpg')),
                          filename: 'test.jpg',
                          content_type: 'image/jpeg')
    end
  end
end
