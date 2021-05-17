# frozen_string_literal: true

class AnswersChangeColumnNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :answers, :question_id, true
  end
end
