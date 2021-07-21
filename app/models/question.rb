# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  after_create :calculate_reputation

  has_many :answers, dependent: :nullify
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true, dependent: :destroy
  belongs_to :user, touch: true

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :create_subscription

  def mark_as_best(answer)
    transaction do
      update!(best_answer: answer)
      reward&.update!(user: answer.user)
    end
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end

  private

  def create_subscription
    subscriptions.create!(user: user)
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
