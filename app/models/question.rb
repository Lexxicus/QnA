# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update!(best_answer: answer)
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
