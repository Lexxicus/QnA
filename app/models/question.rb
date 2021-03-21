class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update!(best_answer_id: answer.id)
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
