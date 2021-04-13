# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :vote
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
