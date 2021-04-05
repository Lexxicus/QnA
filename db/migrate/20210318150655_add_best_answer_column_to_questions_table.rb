# frozen_string_literal: true

class AddBestAnswerColumnToQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :questions do |t|
      t.references :best_answer, foreign_key: { to_table: :answers }
    end
  end
end
