# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    format.html { redirect_to root_url, alert: exception.message }
    format.js { render status: :forbidden }
    format.json { render json: exception.message, status: :forbidden }
  end

  load_and_authorize_resource unless: :devise_controller?
end
