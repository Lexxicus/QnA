# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
end
