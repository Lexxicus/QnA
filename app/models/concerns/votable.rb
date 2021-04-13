# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:vote)
  end

  def vote_up(user)
    voted?(user) ? cancel_vote(user) : votes.create!(user: user, vote: 1)
  end

  def vote_down(user)
    voted?(user) ? cancel_vote(user) : votes.create!(user: user, vote: -1)
  end

  def cancel_vote(user)
    votes.find_by(user_id: user.id).destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  def name_id
    "#{self.class.name.downcase}_#{id}"
  end
end
