# frozen_string_literal: true

class CreateAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :authorizations do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :authorizations, %i[provider uid]
  end
end
