# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def mark_as_best(answer)
    transaction do
      update!(best_answer: answer)
      reward&.update!(user: answer.user)
    end
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
