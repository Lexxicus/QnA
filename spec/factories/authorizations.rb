# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "Provider" }
    uid { "123456" }
  end
end
