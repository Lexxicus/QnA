# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Reward
    @rewards = current_user.rewards
  end
end
