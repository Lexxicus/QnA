# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::Base
      before_action :doorkeeper_authorize!

      rescue_from CanCan::AccessDenied do
        head :forbidden
      end

      protected

      def current_ability
        @ability ||= Ability.new(current_resource_owner)
      end

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
