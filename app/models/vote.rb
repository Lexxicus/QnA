# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user, touch: true

  validates :user, presence: true, uniqueness: { scope: %i[votable_id votable_type] }
  validates :vote, presence: true
  
end
