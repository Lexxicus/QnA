# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    can :recieve_email, User
    can :set_email, User
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User

    can :index, User

    can :create, [Question, Answer, Comment, Subscription]

    can :update, [Question, Answer], user_id: user.id

    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can :mark_as_best, Answer, question: { user_id: user.id }
  end
end
