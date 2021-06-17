# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, :user, :commentable_id, presence: true
end
