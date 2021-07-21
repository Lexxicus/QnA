# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user, touch: true

  has_many_attached :files

  validates :body, presence: true

  after_create :new_answer_notification

  private

  def new_answer_notification
    NotificationJob.perform_later(self)
  end
end
