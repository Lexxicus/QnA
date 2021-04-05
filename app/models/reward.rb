class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :title, presence: true
  validates :image, attached: true, content_type: %i[png jpeg jpg]

  has_one_attached :image
end
