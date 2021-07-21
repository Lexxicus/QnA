# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :question, touch: true
end
