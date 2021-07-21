# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user, optional: true, touch: true

  validates :title, presence: true
  validates :image, attached: true, content_type: %i[png jpeg jpg]

  has_one_attached :image
end
