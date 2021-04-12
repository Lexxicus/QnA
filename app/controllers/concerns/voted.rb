# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: %i[vote_up vote_down]
  end

  def vote_up
    @voted.vote_up(current_user)
    render_json
  end

  def vote_down
    @voted.vote_down(current_user)
    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_resource
    @voted = model_klass.find(params[:id])
  end

  def render_json
    render json: { rating: @voted.rating, type: @voted.name_id }
  end
end
