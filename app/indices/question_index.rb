# frozen_string_literal: true

ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title, sortable: true
  indexes body

  has created_at, updated_at
end
